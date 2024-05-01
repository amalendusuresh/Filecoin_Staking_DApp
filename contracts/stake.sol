// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/// @title FIL Staking Contract
/// @notice This contract allows users to stake FIL tokens and earn rewards based on the staking duration and APR.
contract FILStaking is ReentrancyGuard {
    struct Stake {
        uint256 amount;
        uint256 startTime;
        uint256 lockPeriod;
        uint256 apr;
    }

    address public owner;
    mapping(address => Stake) private stakes;
    mapping(uint256 => bool) private validLockPeriods;

    /// Events
    event Staked(address indexed user, uint256 amount, uint256 lockPeriod, uint256 apr);
    event Withdrawn(address indexed user, uint256 amount, uint256 reward);
    event ContractBalanceUpdated(uint256 newBalance);
    event OwnerWithdrawal(uint256 amountWithdrawn);

    /// @notice Constructor sets the contract owner and initializes valid lock periods.
    constructor() {
        owner = msg.sender;
        validLockPeriods[3] = true;
        validLockPeriods[6] = true;
        validLockPeriods[12] = true;
        validLockPeriods[18] = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    /// @notice Allows users to stake their FIL tokens.
    /// @param _lockPeriod The lock period for the stake in seconds.
    /// @param _apr The annual percentage rate for rewards calculation.
    function stake(uint256 _lockPeriod, uint256 _apr) external payable nonReentrant {
        require(msg.value > 0, "Amount must be greater than 0");
        require(validLockPeriods[_lockPeriod], "Invalid lock period");

        stakes[msg.sender] = Stake(msg.value, block.timestamp, _lockPeriod, _apr);

        emit Staked(msg.sender, msg.value, _lockPeriod, _apr);
        emit ContractBalanceUpdated(address(this).balance);
    }

    /// @notice Allows users to withdraw their stake and rewards after the lock period.
    function withdraw() external nonReentrant {
        Stake storage userStake = stakes[msg.sender];
        require(userStake.amount > 0, "No stake found");
        require(block.timestamp >= userStake.startTime + userStake.lockPeriod, "Lock period not yet over");

        uint256 reward = calculateReward(userStake.amount, userStake.apr, userStake.lockPeriod);
        uint256 totalAmount = userStake.amount + reward;
        payable(msg.sender).transfer(totalAmount);

        emit Withdrawn(msg.sender, userStake.amount, reward);
        emit ContractBalanceUpdated(address(this).balance);

        delete stakes[msg.sender];
    }

    /// @notice Allows the owner to withdraw a specified amount from the contract.
    /// @param _amount The amount to withdraw.
    function ownerWithdraw(uint256 _amount) external onlyOwner {
        uint256 contractBalance = address(this).balance;
        require(contractBalance >= _amount, "Insufficient balance in contract");

        payable(owner).transfer(_amount);
        emit OwnerWithdrawal(_amount);
        emit ContractBalanceUpdated(address(this).balance);
    }

    /// @notice Calculates the reward for a given stake.
    /// @param _amount The amount staked.
    /// @param _apr The annual percentage rate.
    /// @param _lockPeriod The lock period in seconds.
    /// @return reward The calculated reward.
    function calculateReward(uint256 _amount, uint256 _apr, uint256 _lockPeriod) private pure returns (uint256) {
        uint256 timeInYears = _lockPeriod / 31536000; // Convert lock period from seconds to years
        return (_amount * _apr * timeInYears) / 100;
    }

    /// Helper function to convert months to seconds
    function convertMonthsToSeconds(uint256 months) private pure returns (uint256) {
        return months * 30 * 24 * 60 * 60; // Approximation of a month in seconds
    }
}
