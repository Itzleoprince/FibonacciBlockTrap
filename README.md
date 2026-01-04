# FibonacciBlockTrap

A simple, deterministic, Drosera-compatible trap that responds when the current Ethereum block number satisfies a **Fibonacci-style periodic condition**.

This trap is designed as a **proof-of-concept** showcasing safe trap construction, deterministic logic, and correct Drosera workflow on the Hoodi testnet.

---

## Overview

**FibonacciBlockTrap** samples the current block number and checks whether it satisfies a deterministic Fibonacci-based cadence.

To ensure the trap actually triggers on modern block heights, it uses a **Fibonacci-derived modulo condition** rather than checking only early Fibonacci numbers.

If the condition is met, the trap triggers a response via a separate responder contract.

### Key Properties

* ✅ Fully deterministic
* ✅ Stateless
* ✅ Drosera-safe
* ✅ Cheap `collect()`
* ✅ Pure `shouldRespond()`
* ✅ Planner-safe decoding
* ✅ Hoodi testnet compatible

---

## How It Works

### 1. `collect()`

```solidity
function collect() external view override returns (bytes memory) {
    return abi.encode(block.number);
}
```

* Collects the current `block.number`
* Deterministic and cheap
* No external calls or randomness

---

### 2. `shouldRespond(bytes[] data)`

```solidity
function shouldRespond(bytes[] calldata data)
    external
    pure
    override
    returns (bool, bytes memory)
```

* Guards against empty or malformed data
* Decodes the block number
* Applies a **Fibonacci-style periodic condition**
* Returns `(true, abi.encode(blockNumber))` if matched

The condition used is:

```solidity
block.number % 55 == 0
```

`55` is a Fibonacci number and provides a predictable cadence that can actually trigger on a live chain.

---

### 3. Response Contract

The response contract simply emits an event when triggered:

```solidity
event FibonacciBlock(uint256 blockNumber);
```

* No state
* No constructor arguments
* No side effects

---

## File Structure

```
.
├── src
│   ├── FibonacciBlockTrap.sol
│   └── FibonacciBlockResponse.sol
├── drosera.toml
├── .env
└── README.md
```

---

## Deployed Contracts (Hoodi)

* **Trap Contract**
  `0xcfDfbAF5D19a17e5C36eBf49094010250Da2b35b`

* **Response Contract**
  `0x9c4E6eB810188Df449Db3D2d2cfB88ED1FaA3B35`

---

## Deployment

### Prerequisites

* Foundry installed
* Hoodi testnet ETH
  Faucet: [https://stakely.io/faucet/ethereum-hoodi-testnet-eth](https://stakely.io/faucet/ethereum-hoodi-testnet-eth)

---

### Environment Variables (`.env`)

```env
HOODI_RPC_URL=https://ethereum-hoodi-rpc.publicnode.com
PRIVATE_KEY=your_private_key
```

---

### Build

```bash
forge clean
forge build
```

---

### Deploy Response Contract

```bash
forge create src/FibonacciBlockResponse.sol:FibonacciBlockResponse \
  --rpc-url $HOODI_RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast
```

---

### Deploy Trap Contract

```bash
forge create src/FibonacciBlockTrap.sol:FibonacciBlockTrap \
  --rpc-url $HOODI_RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast
```

---

## Testing

### Test `collect()`

```bash
cast call 0xcfDfbAF5D19a17e5C36eBf49094010250Da2b35b \
  "collect()" \
  --rpc-url $HOODI_RPC_URL
```

---

### Test `shouldRespond()` (Triggering example)

```bash
cast call 0xcfDfbAF5D19a17e5C36eBf49094010250Da2b35b \
  "shouldRespond(bytes[])" \
  $(cast abi-encode "bytes[]" $(cast abi-encode "uint256" 55)) \
  --rpc-url $HOODI_RPC_URL
```

Expected:

```
(true, 0x...)
```

---

### Non-triggering Example

```bash
cast call 0xcfDfbAF5D19a17e5C36eBf49094010250Da2b35b \
  "shouldRespond(bytes[])" \
  $(cast abi-encode "bytes[]" $(cast abi-encode "uint256" 56)) \
  --rpc-url $HOODI_RPC_URL
```

Expected:

```
(false, 0x)
```

---

## drosera.toml

```toml
[traps.fibonacci_block_trap]
path = "out/FibonacciBlockTrap.sol/FibonacciBlockTrap.json"
response_contract = "0x9c4E6eB810188Df449Db3D2d2cfB88ED1FaA3B35"
response_function = "respondWithFibonacci(uint256)"
cooldown_period_blocks = 20
min_number_of_operators = 1
max_number_of_operators = 3
block_sample_size = 1
private_trap = true
whitelist = ["0x6e9D3eEab31CF0a47B9e9F00459E86839Feff058"]
```

---

## Determinism & Safety Notes

* No timestamps
* No randomness
* No storage mutations
* No external calls
* No responder calls inside the trap
* Planner-safe decoding
* ABI-aligned payloads

This trap is safe for Drosera relay execution and interface review.

---

## References

* Drosera Hoodi Guide
  [https://github.com/Reiji4kt/Drosera-hoodi](https://github.com/Reiji4kt/Drosera-hoodi)

* Hoodi RPC
  [https://ethereum-hoodi-rpc.publicnode.com](https://ethereum-hoodi-rpc.publicnode.com)

* Hoodi Faucet
  [https://stakely.io/faucet/ethereum-hoodi-testnet-eth](https://stakely.io/faucet/ethereum-hoodi-testnet-eth)

---
