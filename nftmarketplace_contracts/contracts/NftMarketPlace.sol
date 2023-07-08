//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


contract SubscriptionModel{
    mapping(uint256 => uint64) internal _expirations;


    ///@notice emitted when a subscription expiration changes
    ///@dev when a subscription is cancelled, the expiration value should also be 0
    
    event SubscriptionUpdate(uint256 indexed tokenid, uint64 expiration);


    ///@notice renews the subscription to an NFT
    /// @dev Throws if "tokendId" is not a valid NFT
    ///@param _tokenId token of NFT to renww the subscription for
    ///@param duration the number of seconds to extend a subscription fors
    function renewSubscription(uint256 _tokenId, uint64 duration) external payable{
        
        uint64 currentExpiration = _expirations[_tokenId];
        uint64 newExpiration;

        if(currentExpiration == 0){
            //block.timestamp -> current block timestamp as seonds since unix epoch
            newExpiration = uint64(block.timestamp) + duration;
        }else{
            require(isRenewable(), "Subscription not Renewable");
            newExpiration = currentExpiration + duration;
        }

        _expirations[_tokenId] = newExpiration;
        emit SubscriptionUpdate(_tokenId, newExpiration);

    }

    ///@notice cancels the subscription to an NFT
    /// @dev throws if 'tokenid' is not a valid NFT
    /// @param _tokenId  the nft whose subscription is to be cancelled
    function cancelSubscription(uint256 _tokenId) external payable{
        delete _expirations[_tokenId];
        emit SubscriptionUpdate(_tokenId, 0);

    }


    ///@notice get the expiration date of a NFT
    /// @dev if "tokendId" is not a valid NFT
    ///@param _tokenId token of NFT to get expirationdate of
    ///@return uint64 returns the expiration date of an NFT
    function expiresAt(uint256 _tokenId) external view returns (uint64){
        return _expirations[_tokenId];
    }

    /// @notice checks if the NFT is renewable or not
    /// @dev if "tokendId" is not a valid NFT
    /// @return returns the renewability of the specific NFT
    function isRenewable() public pure returns (bool){
        return true;
    }



}

contract NftMarketPlace is SubscriptionModel, ERC721URIStorage{
    constructor() ERC721("NFT Subs", "RGT"){}

    using Counters for Counters.Counter;
    Counters.Counter private tokenIds;
    Counters.Counter private nftsAvailableForSale;
    Counters.Counter private userIds;

    struct nftStruct{
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        address[] subscribers;
        uint256 likes; 
        string title;
        string description;
    }

    struct profileStruct{
        address self;
        address[] followers;
        address[] following;
    }

    mapping(uint256 => nftStruct) private nfts;

    mapping(uint256 => profileStruct) public profiles;

    function getNumberOfUsers() public view returns(uint256){
        uint256 noOfUsers = userIds.current();
        return noOfUsers;
    }



    event NFTStructCreated (
        uint256 tokenId,
        address payable seller,
        address payable owner,
        uint256 price,
        address[] subscribers,
        uint256 likes,
        string title,
        string description
    );



    //sets ntf in state variable to interact later
    function setNFT(uint256 _tokenId, string memory _title, string memory _description) private{

        nfts[_tokenId].tokenId = _tokenId;
        nfts[_tokenId].seller = payable(msg.sender);
        nfts[_tokenId].owner = payable(msg.sender);
        nfts[_tokenId].price = 0;
        nfts[_tokenId].subscribers = [msg.sender];
        nfts[_tokenId].likes = 1;

        emit NFTStructCreated(_tokenId, payable(msg.sender), payable(msg.sender), 0, nfts[_tokenId].subscribers, nfts[_tokenId].likes, _title, _description);

    }



    /// @dev this dunction mints received NFTs
    /// @param _tokenURI the new token URI for the image
    /// @param _title the name of the image
    /// @param _description detailes information on the NFT
    /// @return tokenId of the created NFT
    function createNFT(string memory _tokenURI, string memory _title, string memory _description) public returns (uint256) {
        
        tokenIds.increment();

        uint256 newTokenId = tokenIds.current();

        _mint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);
        setNFT(newTokenId, _title, _description);
        return newTokenId;

    }


    /// @dev sell subscription to the public so thats visible to the nft marketplace
    /// @param _tokenId token id of image
    /// @param _price price for the image\
    /// @return _total number of available subscriptions

    function sellSubscription(uint256 _tokenId, uint256 _price) public returns (uint256) {
        require(_isApprovedOrOwner(msg.sender, _tokenId),  "Only NFT owner can perform this ");

        _transfer(msg.sender, address(this), _tokenId);

        nfts[_tokenId].price = _price;
        nfts[_tokenId].owner = payable(address(this));
        nftsAvailableForSale.increment();

        return nftsAvailableForSale.current();
    }


    /// @dev sell subscription to the public so thats visible to the nft marketplace
    /// @param _tokenId token id of image
    /// @return true
    function buySubscription(uint256 _tokenId) public payable returns (bool) {

        uint256 price = nfts[_tokenId].price;

        require(msg.value == price, "Please send the asking price inorder to complete the purchase");

        payable(nfts[_tokenId].seller).transfer(msg.value);

        //use this only when ure totally selling the NTF, not for subscription bases
        //  _transfer(address(this), msg.sender, _tokenId);

        nfts[_tokenId].subscribers.push(msg.sender);

        return true;
    }




    /// @dev fetch available nfts on sell that will be displayed in marketplace
    /// @return nftStruct[] list of nfts with their metadata
    function getSubscriptions() public view returns (nftStruct[] memory) {

        uint256 subscriptions = nftsAvailableForSale.current();
        uint256 nftCount = tokenIds.current();

        nftStruct[] memory nftSubscriptions =new nftStruct[](subscriptions);

        for(uint256 i = 1; i< nftCount ; i++){

            if(nfts[i].owner == address(this)){
                nftSubscriptions[i] = nfts[i];
            }

        }

        return nftSubscriptions;
    }



    /// @dev fetches NFTs that a specific user is already subscribed to
    /// @return nftStruct[] list of nfts collected by a user with their metadata
    function getCollectables() public view returns(nftStruct[] memory){
            uint256 nftCount = tokenIds.current();
            nftStruct[] memory nftSubscriptions;

            for(uint256 i = 1; i< nftCount; i++){
                uint256 subscribers = nfts[i].subscribers.length;
                    for(uint256 j = 1; j< subscribers; j++){
                        if(nfts[i].subscribers[j] == msg.sender){
                            nftSubscriptions[i] = nfts[i];
                        }
                    }

            }

        return nftSubscriptions;
    }



    /// @dev fetches NFTs that a specific user has created
    /// @return nftStruct[] list of nfts created by a user with their metadata
    function getNFTs() public view returns(nftStruct[] memory){
        uint256 nftCount = tokenIds.current();
        nftStruct[] memory nftSubscriptions;

        for(uint256 i =1; i< nftCount; i++){
            if(nfts[i].seller == msg.sender){
                nftSubscriptions[i] = nfts[i];
            }
        }

        return nftSubscriptions;

    }


    /// @dev fetches details about particular NFT subscription
    /// @param _tokenId token id of the NFT
    /// @return nftStruct NFT data of the specific token Id
    function getIndividualNFT(uint256 _tokenId) public view returns(nftStruct memory){
        return nfts[_tokenId];
    }


    /// @notice this represents user onboardinf
    /// @dev adds msg.sender as the profile

    function addProfile() public {
        uint256 newUserId = userIds.current();
        bool checkIfExists = false;
        for(uint256 i = 1; i< newUserId; i++){
            if(profiles[i].self == msg.sender)
            checkIfExists = true;
        }

        if(!checkIfExists){
            profiles[newUserId].self = msg.sender;
            
        }

        userIds.increment();
    
    }   

    /// @dev in cremebt the following tag of the profile performing the action and the follower tag of the profile that user wants to follow
    /// @param _account the account user wants to follow

    function followProfile(address _account) public{
        uint256 totalCount = userIds.current();
 
        for(uint256 i = 1; i< totalCount; i++){
            if(profiles[i].self == payable(msg.sender)){
                profiles[i].following.push(payable(_account));
            }

            if(profiles[i].self == _account){
                profiles[i].followers.push(payable(msg.sender));
            }

        } 
    }


    /// @dev decrement the following tag of the profule performing the action . and the follower tah of the profile that the user wants to unfollow
    /// @param _account the account the user wants to unfollow
    function unfollowProfile(address _account) public view{
        uint256 totalCount = userIds.current();
        for(uint256 i = 1; i< totalCount; i++){
            removeFollowing(profiles[i].self, profiles[i].followers, _account);
            removeFollower(profiles[i].self, profiles[i].following, payable(msg.sender));

        }
    }

    function removeFollowing(address _owner, address[] memory _followers, address _account) private view {

        if(_owner == _account){
            address[] memory currentFollowing = _followers;
            for(uint256 j = 1; j< currentFollowing.length; j++){
                    if(currentFollowing[j] == payable(msg.sender)){
                        delete currentFollowing[j];
                    }
            }
        }
    }

    function removeFollower(address _owner, address[] memory _following, address _account) private pure {
        if(_owner == _account){
            address[] memory currentFollowers = _following;
            for(uint256 j = 1; j< currentFollowers.length; j++){
                    if(currentFollowers[j] == _account){
                        delete currentFollowers[j];
                    }
            }
        }
    }

    /// @dev increments number of likes for a NFT
    ///@param _tokenId the tokenid of the NFT
    function likeSubscription(uint256 _tokenId) public {
        nfts[_tokenId].likes += 1;
    }


    /// @dev decrement number of likes for a NFT
    ///@param _tokenId the tokenid of the NFT
    function unlikeSubscription(uint256 _tokenId) public {
        nfts[_tokenId].likes -= 1;
    }


}