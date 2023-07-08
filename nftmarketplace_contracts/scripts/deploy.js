const hre = require("hardhat");

async function main() {
  
  const nftMarketPlace = await hre.ethers.deployContract("NftMarketPlace");

  await nftMarketPlace.waitForDeployment();

  const address = await nftMarketPlace.getAddress();
  console.log(
    `deployed contract address ${address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});