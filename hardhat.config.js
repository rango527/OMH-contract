require("@nomiclabs/hardhat-waffle");
require('@openzeppelin/hardhat-upgrades');
require("dotenv").config();
require("hardhat-gas-reporter");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async () => {
  const accounts = await ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

const INFURA_API_KEY =
  process.env.INFURA_API_KEY || "69841a6025c9493a83c583199dc278b3";

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const accounts = [process.env.PRIVATE_KEY];

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      hardfork: 'london',
    },
    maticmainnet: {
      url: "https://polygon-rpc.com/",
      accounts,
      chainId: 137,
      live: true,
      saveDeployments: true,
    },
    matictestnet: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts,
      chainId: 80001,
      live: true,
      saveDeployments: true,
      tags: ["staging"],
      gasPrice: 1000000000,
      gasMultiplier: 1,
    },
  },
  solidity: {
    version: "0.8.10",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  mocha: {
    timeout: 50000,
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_KEY_POLYGON,
  },
};
