# OMH ERC20 and Distribution contract

## Package install
yarn 
---or---
npm install

### Deploy contracts to Rinkeby testnet
yarn deploy-rinkeby
---or---
npm run deploy-rinkeby

### Verify
- Distribution
npx hardhat verify --network rinkeby --contract contracts/Distribution.sol:Distribution 0x920Da257819262FfAAd139e4548339b0979B5C87 1652572800
- OMHERC20
npx hardhat verify --network rinkeby --contract contracts/OMHERC20.sol:OMHERC20 0x9003D3364FE7a28624EA3f8dD88749b6888bC2fC 0x920Da257819262FfAAd139e4548339b0979B5C87
