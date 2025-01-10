# Ripple Shield - Smart Contract Repository

This repository contains the Ethereum smart contract source code for **Ripple Shield**, a blockchain-powered travel insurance platform. Ripple Shield revolutionizes travel insurance by leveraging XRPL (XRP Ledger) and EVM-compatible smart contracts to offer automated, data-backed instant payouts, transparent claims, and seamless multi-currency support.


## **About Ripple Shield**
Ripple Shield is designed to address the inefficiencies of traditional travel insurance by automating claims processing, reducing administrative costs, and enhancing transparency. Using blockchain technology, it provides:
- Instant payouts for parametric insurance events (e.g., flight delays, cancellations).
- Secure and immutable claims documentation via decentralized ledgers.
- Multi-currency payouts, including cryptocurrencies, for global travellers.

## **Contents of This Repository**
- **`.deps/`**: Dependency files and references for the smart contract.
- **`.states/vm-cancun/`**: Configuration and state data for the EVM-compatible sidechain.
- **`contracts/`**: Ethereum smart contract source code for Ripple Shield, including implementations for ERC20 token handling and insurance logic.
- **`compiler_config.json`**: Configuration file for Solidity compiler settings.

## **Key Features**
1. **Smart Contracts**:
   - Implemented using Solidity for automating payouts based on predefined conditions.
   - Handles ERC20 tokens for multi-currency support.

2. **Blockchain Integration**:
   - Utilizes XRPL EVM-compatible sidechain for enhanced speed and reduced transaction costs.
   - Cross-chain interoperability for seamless token transactions.

3. **Automated Claims Processing**:
   - Real-time API integrations validate parametric events (e.g., flight delays) and trigger payouts.
