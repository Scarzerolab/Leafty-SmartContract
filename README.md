# Leafty-SmartContract

<pre align="center">
██╗     ███████╗ █████╗ ███████╗████████╗██╗   ██╗
██║     ██╔════╝██╔══██╗██╔════╝╚══██╔══╝╚██╗ ██╔╝
██║     █████╗  ███████║█████╗     ██║    ╚████╔╝ 
██║     ██╔══╝  ██╔══██║██╔══╝     ██║     ╚██╔╝  
███████╗███████╗██║  ██║██║        ██║      ██║   
╚══════╝╚══════╝╚═╝  ╚═╝╚═╝        ╚═╝      ╚═╝   
</pre>

## Overview

The ReportManager contract provides a decentralized, immutable ledger for recording daily reports related to environmental conditions, care actions, and plant/crop health status. It is ideal for tracking daily farm, garden, or other regulated environmental data.

Each report is assigned a unique ID and includes structured data for weather, soil, health, and care activities, along with a timestamp and the submitting address.

## Features

 - Immutable Data Storage: All reports are permanently stored on the blockchain.
 - Structured Reporting: Utilizes enums and structs to enforce structured reporting on Weather, Soil, Plant Health, and Care Actions.
 - Timestamping: Reports automatically record the submission time using `block.timestamp`
 - Date Key Generation: Uses the `BokkyPooBahsDateTimeLibrary` to convert timestamps into a date key (`YYYYMMDD` format) for easier querying.
 - Owner Control: Includes a basic ownership mechanism for administrative functions like transferring ownership.
 - Flexible Data Retrieval: Allows retrieval of reports by ID, in batches, or specific data subsets (e.g., just the weather data).

## Dependencies

This contract imports an external library for date and time utility:
- `BokkyPooBahsDateTimeLibrary`: Used for converting Unix timestamps into a YYYYMMDD integer format (getDateKey) and for getting the day of the week.

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build

$ forge test

$ forge fmt

$ forge snapshot

$ anvil

$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>

$ cast <subcommand>

$ forge --help
$ anvil --help
$ cast --help


Save the file.

---

### ✅ **Step 2: Mark the conflict as resolved**
In your terminal:
```bash
git add README.md
