// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/** 
 * @title TokenStaking Contract 
 * @dev A smart contract for staking native tokens of the Filecoin network for a specified period of time. 
 */ 
contract TokenStaking is Ownable, ReentrancyGuard {
    // Using SafeMath methods for arithmetic operations
    using SafeMath for uint256;

    // Using EnumerableSet library to use sets of unsigned integers
    using EnumerableSet for EnumerableSet.UintSet;

    // Struct to represent a single staking commitment
    struct StakingCommitment {
        address staker;  // The address of the staker
        uint256 stakedAmount; // The amount of FIL tokens being staked
        uint256 stakingPeriod;  // The length of the staking period, in months
        uint256 startTime;  // The start time of the staking period, in seconds since epoch
        uint256 endTime;    // The end time of the staking period, in seconds since epoch
        bool isWithdrawn; // Adding flag to mark if stake is withdrawn
    }

    // Array to hold all staking commitments
    // The list of staking commitments made by users
    StakingCommitment[] public commitments;

    // Mapping to keep track of each user's staked amount
    // The amount of FIL tokens staked by each user
    mapping(address => uint256) public stakedAmounts;

    // Stores an array of uint256 values for each wallet address.
    mapping(address => EnumerableSet.UintSet) private commitmentIndex;

    // The total amount of FIL tokens staked by all users
    uint256 public totalStakedAmount;

    // Set to store the valid staking periods in months, set by the owner of the contract
    EnumerableSet.UintSet private stakingPeriods;

    // Events
    event Staked(address indexed staker, uint256 amount, uint256 stakingPeriod, uint256 startTime, uint256 endTime);
    event Withdrawn(address indexed staker, uint256 stakedAmount);
    event CommitmentAdded(address indexed wallet, uint256 indexed index);
     event StakingPeriodsChanged(uint256 indexed newStakingPeriod);
   
   
    // Constructor 
    constructor() { 
        // Initialize the staking periods
        stakingPeriods.add(18);
    }

    /// @notice Allows a user to stake a specified amount of FIL tokens for a specified period of time
    /// @param _stakingPeriod The duration of the staking period, which must be one of the staking periods set by the owner.
    function stake(uint256 _stakingPeriod) public payable returns (uint256) {
        // Validating staker's address
        require(msg.sender != address(0), "Staker's address must not be a zero address");

        // Validating staking period
        require(
            isStakingPeriodValid(_stakingPeriod),
            "Invalid staking period"
        );

        // Getting the current time
        uint256 startTime = block.timestamp;

         // Calculate the number of seconds in 18 months
        uint256 stakingPeriodInSeconds = _stakingPeriod.mul(30 days);

        // Calculating the end time of the staking period
         uint256 endTime = startTime.add(stakingPeriodInSeconds);

        // Creating a new staking commitment
        StakingCommitment memory commitment = StakingCommitment(
            msg.sender,
            msg.value,
            _stakingPeriod,
            startTime,
            endTime,
            false
        );

        // Adding the commitment to the list of commitments
        commitments.push(commitment);

        // Adding the commitment index to the wallet's commitmentIndex array
        commitmentIndex[msg.sender].add(commitments.length - 1);

        // Updating the user's staked amount
        stakedAmounts[msg.sender] = stakedAmounts[msg.sender].add(msg.value);

        // Updating the total staked amount
        totalStakedAmount = totalStakedAmount.add(msg.value);

        // Emitting a Staked event to indicate that the tokens have been staked for a period of time
        emit Staked(msg.sender, msg.value, _stakingPeriod, startTime, endTime);

        // Emitting a CommitmentAdded event to notify listeners that a new staking commitment has been added
        emit CommitmentAdded(msg.sender, commitments.length - 1);

        // Returning the commitment index
        return commitments.length - 1;
    }

    function withdraw(uint256 _commitmentIndex) public nonReentrant {
        // Validating commitment index
        require(_commitmentIndex >= 0 && _commitmentIndex < commitments.length, "Invalid commitment index");

        // Checking if the commitment has already been withdrawn
        require(!commitments[_commitmentIndex].isWithdrawn, "Already been withdrawn for this commitment");

        // Checking if the caller is the staker
        require(msg.sender == commitments[_commitmentIndex].staker, "Only the staker can withdraw");

        // Checking if the staking period is over
        require(block.timestamp >= commitments[_commitmentIndex].endTime, "Staking period is not over yet");

        // Getting the staked amount of the commitment
        uint256 stakedAmount = commitments[_commitmentIndex].stakedAmount;

        // Marking the commitment as withdrawn
        commitments[_commitmentIndex].isWithdrawn = true;

        // Checking if the user's staked amount is greater than or equal to the staked amount in the commitment
        require(stakedAmounts[msg.sender] >= commitments[_commitmentIndex].stakedAmount, "Insufficient staked amount");

        // Updating the user's staked amount
        stakedAmounts[msg.sender] = stakedAmounts[msg.sender].sub(commitments[_commitmentIndex].stakedAmount);

        // Updating the total staked amount
        totalStakedAmount = totalStakedAmount.sub(commitments[_commitmentIndex].stakedAmount);

        // Transfer the staked amount to the staker's account
        payable(msg.sender).transfer(stakedAmount);

        // Emitting an event to notify listeners that a withdrawal has been made
        emit Withdrawn(msg.sender, stakedAmount);
    }


    /// @notice Checks if a staking period is valid
    /// @param _stakingPeriod The duration of the staking period, in months
    /// @return A boolean value indicating if the staking period is valid or not
    function isStakingPeriodValid(uint256 _stakingPeriod) public view returns (bool) {
        return stakingPeriods.contains(_stakingPeriod);
    }

    // Getters

    /// @notice Returns the token balance of the Staking contract
    /// @return A uint256 value representing the token balance of the Staking contract
    function getStakingContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    /// @notice Returns the number of staking commitments that have been made in the contract
    /// @return A uint256 value representing the number of staking commitments made in the contract
    function getStakingCommitmentsCount() public view returns (uint256) {
        return commitments.length;
    }

    /// @notice Returns the amount of tokens that a specific staker has staked in the contract
    /// @param _staker The address of the staker to check
    /// @return A uint256 value representing the staked amount for the given staker
    function getStakedAmount(address _staker) public view returns (uint256) {
        return stakedAmounts[_staker];
    }

    /// @notice Returns the total amount of tokens that have been staked in the contract
    /// @return A uint256 value representing the total staked amount
    function getTotalStakedAmount() public view returns (uint256) {
        return totalStakedAmount;
    }

    /// @notice This function is used to get the array of commitment indices for a specific user
    /// @param wallet The wallet address to retrieve commitment indices for
    /// @return An array of uint256 values representing the commitment indices for the given user
    function getCommitmentIndex(address wallet) external view returns (uint256[] memory) {
        uint256[] memory indices = new uint256[](commitmentIndex[wallet].length());
        for (uint256 i = 0; i < commitmentIndex[wallet].length(); i++) {
            indices[i] = commitmentIndex[wallet].at(i);
        }
        return indices;
    }

    /// @notice Returns the array of all staking commitments made on this contract.
    function getCommitment() external view returns (StakingCommitment[] memory) {
        return commitments;
    }

    // Function to get the balance of the owner's account
    function getOwnerBalance() public view returns (uint256) {
        return address(owner()).balance;
    }


    // Setters

     
    /// @notice Allows the contract owner to update the staking periods
    /// @dev Only the contract owner can call this function
    /// @param newStakingPeriods An array of uint256 values representing the new staking periods
    function setStakingPeriods(uint256[] calldata newStakingPeriods) external onlyOwner {
        // Clear the existing staking periods
        for (uint256 i = 0; i < stakingPeriods.length(); i++) {
            stakingPeriods.remove(stakingPeriods.at(i));
        }

        // Add the new staking periods
        for (uint256 i = 0; i < newStakingPeriods.length; i++) {
            stakingPeriods.add(newStakingPeriods[i]);
        }

        emit StakingPeriodsChanged(newStakingPeriods.length);
    }


    // Function to allow the owner to withdraw the staked tokens from the contract
    function withdrawStakedTokensByOwner(uint256 amount) external onlyOwner {
        uint256 stakedTokens = address(this).balance;
        require(stakedTokens >= amount, "Insufficient staked tokens to withdraw");

        // Transfer the staked tokens to the owner's address
        payable(owner()).transfer(amount);
    }

    // Function to allow the owner to transfer the staked tokens back to the staking contract
    function transferStakedTokensToContractByOwner(uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be greater than zero");

        // Transfer the staked tokens back to the staking contract
        payable(address(this)).transfer(amount);
    }

    


}