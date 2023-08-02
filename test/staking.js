const { expect } = require("chai");
const { ethers } = require("hardhat");


describe("TokenStaking", function () {
  it("should allow users to stake tokens for a specified period of time", async function () {
    // Deploy the TokenStaking contract
    const TokenStaking = await ethers.getContractFactory("TokenStaking");
    const tokenStaking = await TokenStaking.deployed();

    // Get the staking period
    const stakingPeriod = 18;

    // Get the stakers' addresses
    const [owner, staker] = await ethers.getSigners();

    // Get the staking amount
    const stakedAmount = ethers.utils.parseEther("10");

    // Stake tokens
    await tokenStaking
      .connect(staker) // Specify the signer for the transaction
      .stake(stakingPeriod, { value: stakedAmount });

    // Get the staker's staked amount
    const stakerStakedAmount = await tokenStaking.getStakedAmount(staker.address);

    // Assert that the staker's staked amount is equal to the staked amount
    expect(stakerStakedAmount).to.equal(stakedAmount);
  });
});