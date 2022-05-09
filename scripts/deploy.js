const hre = require("hardhat");

async function main() {
  // We get the contract to deploy
  const OMHERC20 = await hre.ethers.getContractFactory("OMHERC20");
  const ERC20 = await OMHERC20.deploy();
  // 0x7D686Ff7a4d436Ed10675A7F0E83Fd41477b0717
  await ERC20.deployed();

  console.log("OMHERC20 deployed to:", ERC20.address);

  const Distribution = await hre.ethers.getContractFactory("Distribution");
  // Sun May 15 2022 00:00:00 UTC+0
  const distribution = await Distribution.deploy(ERC20.address, '0x7D686Ff7a4d436Ed10675A7F0E83Fd41477b0717', 1652572800);
  // 0x7D686Ff7a4d436Ed10675A7F0E83Fd41477b0717
  await distribution.deployed();

  console.log("Distribution deployed to:", distribution.address);

  await ERC20.approve(distribution.address, type(uint256).max);
  console.log('OMHToken approved!');
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
