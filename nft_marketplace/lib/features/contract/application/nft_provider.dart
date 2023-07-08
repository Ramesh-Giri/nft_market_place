import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nft_marketplace/utils/config.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class NftProvider extends ChangeNotifier {
  Web3Client? _web3client;
  ContractAbi? _abiCode;
  EthereumAddress? _contractAddress;
  DeployedContract? _deployedContract;
  final EthPrivateKey _creds = EthPrivateKey.fromHex(dummyPrivateKey);
  ContractFunction? _addProfile;
  ContractFunction? _profileCount;
  ContractFunction? _getProfile;
  double _balance = 0.00;
  int profileCount = 0;
  List<dynamic> _myProfile = [];

  double get balance => _balance;

  Future<void> init() async {
    _web3client = Web3Client(url, http.Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });

    await getABI();
    await getDeployedContract();
  }

  Future<void> getABI() async {
    final String abiFile = await rootBundle.loadString("assets/json/abi.json");
    final jsonABI = await json.decode(abiFile);

    _abiCode = ContractAbi.fromJson(
        json.encode(jsonABI['abi']), json.encode(jsonABI['contractName']));

    _contractAddress = EthereumAddress.fromHex(dummyAddress);
  }

  Future<void> getDeployedContract() async {
    if (_abiCode != null && _contractAddress != null) {
      _deployedContract = DeployedContract(_abiCode!, _contractAddress!);
      try {
        _addProfile = _deployedContract!.function("addProfile");
        _profileCount = _deployedContract!.function("getNumberOfUsers");
        _getProfile = _deployedContract!.function("profiles");
      } catch (e) {
        print('deploy contract error ${e.toString()}');
      }
    }
  }

  Future<void> addProfile() async {
    await init();
    try {
      await _web3client!.sendTransaction(
          _creds,
          Transaction.callContract(
              nonce: await _web3client!
                  .getTransactionCount(EthereumAddress.fromHex(dummyAddress)),
              from: EthereumAddress.fromHex(dummyAddress),
              contract: _deployedContract!,
              function: _addProfile!,
              parameters: []),
          chainId: 1337);

      EtherAmount ethBalance =
          await _web3client!.getBalance(EthereumAddress.fromHex(dummyAddress));
      _balance = ethBalance.getValueInUnit(EtherUnit.ether);
      notifyListeners();
    } catch (e, stack) {
      print('add profile error ${e.toString()}');
      print('add profile error tracec ${stack.toString()}');
    }
  }

  Future<void> getMyProfile() async {
    await init();
    try{

      List profileList = [];
      try{
        var response = await _web3client!.call(
            contract: _deployedContract!, function: _profileCount!, params: []);

        print('profile list $response');
      }catch(e){
        print('get my profile function  error ${e.toString()}');

      }
      int totalProfiles = profileList[0];
      profileCount = totalProfiles.toInt();

      List allProfiles = [];
      for (int i = 1; i < profileCount; i++) {
        List temp = await _web3client!.call(
            contract: _deployedContract!,
            function: _getProfile!,
            params: [BigInt.from(i)]);allProfiles.add(temp);
      }

      for (var item in allProfiles) {
        if (item[0] == EthereumAddress.fromHex(dummyAddress)) {
          _myProfile = item;
        }
      }

      notifyListeners();

    }catch(e){
      print('get my profile error ${e.toString()}');
    }

  }
}