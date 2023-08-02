const { ethers } = require("hardhat");

async function main() {
  // Set up the account that will deploy the contract
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  // Deploy TokenStaking contract
  const TokenStaking = await ethers.getContractFactory("TokenStaking");
  const tokenStaking = await TokenStaking.deploy();

  await tokenStaking.deployed();

  console.log("TokenStaking contract deployed to:", tokenStaking.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
