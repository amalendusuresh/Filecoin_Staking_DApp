import React, { useState, useEffect } from "react";
import Web3 from "web3";
import TokenStakingABI from "./artifacts/contracts/Staking.sol/TokenStaking.json";

function App() {
  const [web3, setWeb3] = useState(undefined);
  const [stakeAmount, setStakeAmount] = useState(0);
  const [stakingPeriod, setStakingPeriod] = useState(12);
  const [commitmentIndex, setCommitmentIndex] = useState(0);
  const [message, setMessage] = useState("");
  const [totalStakedAmount, setTotalStakedAmount] = useState(0);
  const [getNetwork, setGetNetwork] = useState(undefined);
  const [contracts, setContracts] = useState(undefined);
  const [contractAddress, setContractAddress] = useState(undefined);
  const [mmStatus, setMmStatus] = useState("Not connected!");
  const [isConnected, setIsConnected] = useState(false);
  const [accountAddress, setAccountAddress] = useState(undefined);

  useEffect(() => {
    (async () => {
      // Define web3
      if (window.ethereum) {
        const web3 = new Web3(window.ethereum);
        setWeb3(web3);
        // get networkId
        const networkId = await web3.eth.getChainId();
        setGetNetwork(networkId);
        // INSERT deployed smart contract address
        const contractAddress = "0xE63731D425A77066cc9a1b2CAf3EAFE59609D07f";
        setContractAddress(contractAddress);
        // Instantiate smart contract instance
        const TokenStaking = new web3.eth.Contract(
          TokenStakingABI.abi,
          contractAddress
        );
        setContracts(TokenStaking);
        // Set provider
        TokenStaking.setProvider(window.ethereum);
      } else {
        setMmStatus("⚠️ No wallet detected! Please install Metamask.");
      }
    })();
  }, []);

  // Connect to Metamask wallet
  async function connectWallet() {
    // Check Metamask status
    if (window.ethereum) {
      setMmStatus("✅ Metamask detected!");
      try {
        // Metamask popup will appear to connect the account
        const accounts = await window.ethereum.request({
          method: "eth_requestAccounts",
        });
        // Get address of the account
        setAccountAddress(accounts[0]);
        setIsConnected(true);
      } catch (error) {
        console.log("Error: ", error);
      }
    } else {
      setMmStatus("⚠️ No wallet detected! Please install Metamask.");
    }
  }

  useEffect(() => {
    const fetchTotalStakedAmount = async () => {
      if (contracts) {
        try {
          const totalStaked = await contracts.methods.getTotalStakedAmount().call();
          setTotalStakedAmount(totalStaked);
        } catch (error) {
          console.error("Error fetching total staked amount:", error);
        }
      }
    };
    fetchTotalStakedAmount();
  }, [contracts]);

  const handleStake = async () => {
    if (!contracts || !web3 || !accountAddress) {
      console.warn("Contract, web3, or account not properly initialized.");
      return;
    }
  
    try {
      const stakeInWei = web3.utils.toWei(stakeAmount.toString(), "ether");
      console.log("Staking amount in Wei:", stakeInWei);
  
      // Call the stake() method and get the returned values directly
      const commitmentIndex = await contracts.methods.stake(stakingPeriod).send({ from: accountAddress, value: stakeInWei });
  
      // The returned value is the commitment index directly
      const index = commitmentIndex.events.CommitmentAdded.returnValues.index;;
  
      // The staking end time is directly returned as well
      const stakingEndTimeInSeconds = commitmentIndex;

      console.log("Stake successful! Commitment Index:", index);
  
      // The start time stamp doesn't seem to be returned, so you can use the current time instead
      const startTimeStamp = Math.floor(Date.now() / 1000);
      const startDate = new Date(startTimeStamp * 1000).toLocaleDateString();
      console.log("Start Date:", startDate);
  
      // As mentioned earlier, it's unclear where this end timestamp is coming from, but you can use the current time as well
      const endTimeStamp = Math.floor(Date.now() / 1000) + stakingPeriod * 30 * 24 * 60 * 60; // Assuming each month has 30 days
      const endDate = new Date(endTimeStamp * 1000).toLocaleDateString();
      console.log("End Date:", endDate);
  
      
      setMessage("Stake successful!");
    } catch (error) {
      console.error("Error staking tokens:", error);
      setMessage("Error staking tokens: " + error.message);
    }
  };
  
  
  

  const handleWithdraw = async () => {
    if (contracts && web3) {
      try {
        await contracts.methods.withdraw(commitmentIndex).send({ from: accountAddress });
        setMessage("Withdrawal successful!");
      } catch (error) {
        setMessage("Error withdrawing tokens: " + error.message);
      }
    }
  };

  return (
    <div>
      <h1>Token Staking App</h1>
      <p>Status: {mmStatus}</p>
      <p>Network ID: {getNetwork}</p>
      <p>Connected Account: {accountAddress}</p>
      <div>
        {!isConnected ? (
          <button onClick={connectWallet}>Connect Wallet</button>
        ) : (
          <div>
            <br />
            <h3>Staking</h3>
            <p>Total Staked Amount: {totalStakedAmount} ETH</p>
            <label>Stake Amount (ETH): </label>
            <input
              type="number"
              value={stakeAmount}
              onChange={(e) => setStakeAmount(e.target.value)}
            />
            <br />
            <label>Staking Period (in months): </label>
            <input
              type="number"
              value={stakingPeriod}
              onChange={(e) => setStakingPeriod(e.target.value)}
            />
            <br />
            <button onClick={handleStake}>Stake Tokens</button>
            <p>{message}</p>
            <br />
            
            <h3>Withdraw</h3>
            <label>Commitment Index: </label>
            <input
              type="number"
              value={commitmentIndex}
              onChange={(e) => setCommitmentIndex(e.target.value)}
            />
            <br />
            <button onClick={handleWithdraw}>Withdraw Tokens</button>
            <p>{message}</p>
          </div>
        )}
      </div>
    </div>
  );
}

export default App;
