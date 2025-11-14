# Leafty-SmartContract

<pre align="center">
██╗     ███████╗ █████╗ ███████╗████████╗██╗   ██╗
██║     ██╔════╝██╔══██╗██╔════╝╚══██╔══╝╚██╗ ██╔╝
██║     █████╗  ███████║█████╗     ██║    ╚████╔╝ 
██║     ██╔══╝  ██╔══██║██╔══╝     ██║     ╚██╔╝  
███████╗███████╗██║  ██║██║        ██║      ██║   
╚══════╝╚══════╝╚═╝  ╚═╝╚═╝        ╚═╝      ╚═╝                                                     
</pre>

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
