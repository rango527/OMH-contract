# OMH ERC20 and Distribution contract

## Package install
yarn 
---or---
npm install

### Build contracts
yarn build
---or---
npm run build

### Deploy contracts to Rinkeby testnet
yarn deploy-rinkeby
---or---
npm run deploy-rinkeby

### Verify
- Distribution
npx hardhat verify --network rinkeby --contract contracts/Distribution.sol:Distribution <Deployed Contract Address> 1652572800
- OMHERC20
npx hardhat verify --network rinkeby --contract contracts/OMHERC20.sol:OMHERC20 <Deployed Contract Address> <Deployed Distribution Contract Address> 
