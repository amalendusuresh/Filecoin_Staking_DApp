# Filecoin Staking DApp

A **decentralized application** that lets users stake **Filecoin (FIL)** tokens on the **Filecoin Ethereum Virtual Machine (FEVM)** and earn rewards over a fixed **18-month staking period**. Built with Solidity smart contracts and a React frontend — designed for a long-term, set-and-forget staking experience on the Filecoin network.

![Solidity](https://img.shields.io/badge/Solidity-0.8.x-363636?logo=solidity)
![FEVM](https://img.shields.io/badge/Network-Filecoin%20FEVM-0090FF?logo=filecoin&logoColor=white)
![Hardhat](https://img.shields.io/badge/Built%20with-Hardhat-FFF100?logo=hardhat&logoColor=black)
![React](https://img.shields.io/badge/Frontend-React-61DAFB?logo=react&logoColor=black)
![Tailwind](https://img.shields.io/badge/UI-TailwindCSS-38B2AC?logo=tailwind-css&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-blue)

---

## 🌐 Live Demo

🚀 **[alpha.stakesphere.io](https://alpha.stakesphere.io)** — Try the staking interface live.

---

## ✨ Features

- ✅ **Stake FIL tokens** directly through the DApp with one click
- ✅ **Fixed 18-month staking duration** — optimized for long-term yield
- ✅ **FEVM-native** — Solidity contracts running on Filecoin's EVM-compatible layer
- ✅ **Automated reward distribution** — calculated and paid out programmatically
- ✅ **MetaMask integration** — seamless wallet connection
- ✅ **Responsive React + Tailwind UI**
- ✅ **OpenZeppelin foundations** — built on audited primitives

---

## 🏗️ Architecture

```
   ┌─────────────────┐          ┌──────────────────┐
   │   React + UI    │ ────────►│   MetaMask /     │
   │  (Tailwind)     │  signs   │   Ethers.js      │
   └────────┬────────┘          └────────┬─────────┘
            │ reads state                │ tx
            ▼                            ▼
   ┌──────────────────────────────────────────────┐
   │           Filecoin EVM (FEVM)                │
   │  ┌─────────────────────────────────────────┐ │
   │  │  Staking.sol                            │ │
   │  │  • stake(amount)                        │ │
   │  │  • withdraw()  [after 18 months]        │ │
   │  │  • claimRewards()                       │ │
   │  └─────────────────────────────────────────┘ │
   └──────────────────────────────────────────────┘
```

---

## 📂 Project Structure

```
Filecoin_Staking_DApp/
├── contracts/            # Solidity staking contracts
├── scripts/              # Hardhat deployment scripts
├── test/                 # Contract test suite
├── src/                  # React frontend source
├── public/               # React static assets
├── hardhat.config.js     # Hardhat config (FEVM networks)
├── tailwind.config.js    # Tailwind config
├── package.json
├── LICENSE               # MIT
└── README.md
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Smart Contracts** | Solidity 0.8.x · OpenZeppelin |
| **Dev Framework** | Hardhat |
| **Network** | Filecoin EVM (Calibration / Mainnet) |
| **Frontend** | React.js · TailwindCSS |
| **Wallet** | MetaMask + Ethers.js |

---

## 🚀 Getting Started

### Prerequisites

- **Node.js** ≥ 16.x (originally tested on v12+, recommend ≥18 for current Hardhat)
- **npm** or **Yarn**
- **MetaMask** browser extension configured for the Filecoin (FEVM) network
- Some **tFIL** for testing (Calibration testnet) or **FIL** for mainnet

### Installation

```bash
# Clone the repository
git clone https://github.com/amalendusuresh/Filecoin_Staking_DApp.git
cd Filecoin_Staking_DApp

# Install dependencies
npm install
```

### Environment Setup

Create a `.env` file in the project root:

```bash
REACT_APP_FEVM_RPC_URL=YourFEVMRPCUrl
PRIVATE_KEY=YourWalletPrivateKey
```

> ⚠️ **Never commit your `.env` file or private key** — `.gitignore` should already exclude it.

### Compile & Deploy

```bash
# Compile contracts
npx hardhat compile

# Deploy to FEVM Calibration testnet
npx hardhat run scripts/deploy.js --network calibrationnet

# Or deploy to FEVM Mainnet
npx hardhat run scripts/deploy.js --network filecoin
```

### Run the Frontend

```bash
npm start
```

The DApp will open at [http://localhost:3000](http://localhost:3000).

---

## 💡 How to Use

1. **Connect Wallet** — open the DApp and connect MetaMask. Make sure you're on the Filecoin / FEVM network.
2. **Enter Stake Amount** — input the amount of FIL you want to stake.
3. **Approve & Stake** — confirm the transaction in MetaMask. Your tokens are locked in the staking contract.
4. **Earn Rewards** — rewards accrue automatically based on stake size and elapsed time.
5. **Claim or Withdraw** — claim earned rewards at any time. Principal unlocks after the 18-month period.

---

## 🔐 Security Considerations

- **Reentrancy protection** on all state-changing functions
- **Time-locked withdrawals** — principal can't be withdrawn before the 18-month period
- **OpenZeppelin contracts** as the foundation for token & access control
- **Solidity 0.8.x** — built-in overflow/underflow protection
- **Owner-restricted admin functions** with explicit access modifiers

> ⚠️ This DApp is currently in **alpha** ([alpha.stakesphere.io](https://alpha.stakesphere.io)) and has not been formally audited. Use testnet (Calibration) for evaluation before mainnet.

---

## 🗺️ Roadmap

- [ ] Flexible staking periods (3 / 6 / 12 / 18 months) with tiered APY
- [ ] Liquid staking — receive a transferable receipt token (stFIL)
- [ ] Multi-asset staking (wrapped Filecoin + ERC-20 reward tokens)
- [ ] On-chain governance for reward parameters
- [ ] Subgraph for indexing stake events & TVL analytics
- [ ] Mobile-responsive PWA build
- [ ] Formal audit before mainnet GA

---

## 📄 License

MIT © [Amalendu Suresh](https://github.com/amalendusuresh)

---

## 🤝 Contact

**Amalendu Suresh** — Blockchain Engineer

- 💼 **LinkedIn:** [amalendu-blockchain](https://www.linkedin.com/in/amalendu-blockchain/)
- ✍️ **Medium:** [@amalenduvishnu](https://medium.com/@amalenduvishnu)
- 📧 **Email:** amalendusuresh95@gmail.com

If you find this project useful, please ⭐ star the repo!
