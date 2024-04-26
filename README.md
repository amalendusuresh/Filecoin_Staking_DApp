# Filecoin Staking DApp

 This is a decentralized application enables users to stake Filecoin (FIL) tokens using the Filecoin Ethereum Virtual Machine (FEVM) and earn rewards over an 18-month period. Built using Solidity and React.js, this project aims to provide a robust and user-friendly interface for long-term staking on the Filecoin network.

# Features
*  FIL Token Staking: Users can stake their FIL tokens directly through the DApp to earn rewards.
*  Fixed Staking Duration: Staking term fixed at 18 months to optimize reward potential.
*  FEVM Compatibility: Utilizes the Filecoin Ethereum Virtual Machine for seamless integration with Ethereum's ecosystem.
*  Automated Reward Distribution: Rewards are calculated and distributed automatically based on the staking amount and duration.
  
# Technologies Used
*  Solidity: Smart contract programming language used for writing the staking logic on the FEVM.
*  Hardhat: Ethereum development environment for compiling, deploying, and testing Ethereum software.
*  React.js: A JavaScript library for building user interfaces, employed here to create a responsive front-end.
*  FEVM: Filecoin Ethereum Virtual Machine, enabling Solidity-based smart contracts to run on the Filecoin network.

# Prerequisites
*  Node.js installed (v12.x or higher)
*  Yarn or npm installed
*  MetaMask browser extension installed and connected to the Filecoin (via FEVM) network

# Installation
* Clone the repository

        https://github.com/amalendusuresh/Filecoin_Staking_DApp.git

* Install dependencies

        npm install
  
* Create a .env file in the root directory

        REACT_APP_FEVM_RPC_URL="YourFEVMRPCUrl"
        PRIVATE_KEY="YourWalletPrivateKey"

* Compile and deploy the smart contracts

        npx hardhat compile
        npx hardhat run scripts/deploy.js --network 

  
* Start the React application
  
          npm start

#  How to Use
*  Connect your MetaMask Wallet: Use MetaMask to connect to the FEVM network.
*  Navigate to the Staking Section: Enter the amount of FIL you wish to stake.
*  Confirm the Transaction: Approve the transaction via MetaMask to stake your FIL tokens.
