# d-blog Smart Contracts

This directory contains the smart contracts for the d-blog platform.

## Setup

1. Install dependencies:

    ```bash
    npm install
    ```

2. Compile the contracts:

    ```bash
    npm run compile
    ```

3. Deploy the contracts:

    ```bash
    npm run deploy --network <network>
    ```

Replace `<network>` with the desired network configuration in `hardhat.config.js`.

## Dependencies

- [OpenZeppelin Contracts](https://openzeppelin.com/contracts/)
- [Hardhat](https://hardhat.org/)
