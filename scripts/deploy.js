const hre = require("hardhat");

async function main() {
  // We get the contract to deploy
  const Distribution = await hre.ethers.getContractFactory("Distribution");
  // 1652572800 is startDate (Sun May 15 2022 00:00:00 UTC+0)
  const distribution = await Distribution.deploy(1652572800);
  // 0x7D686Ff7a4d436Ed10675A7F0E83Fd41477b0717
  await distribution.deployed();
  console.log("Distribution deployed to:", distribution.address);

  const OMHERC20 = await hre.ethers.getContractFactory("OMHERC20");
  const ERC20 = await OMHERC20.deploy(distribution.address);
  // 0x7D686Ff7a4d436Ed10675A7F0E83Fd41477b0717
  await ERC20.deployed();

  console.log("OMHERC20 deployed to:", ERC20.address);

  await distribution.setOMHToken(ERC20.address);
  const OMHTokenAddress = await distribution.OMHToken();
  console.log('Set OMHToken address:', OMHTokenAddress);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
