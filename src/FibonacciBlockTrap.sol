// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "drosera-contracts/interfaces/ITrap.sol";

/**
 * @title FibonacciBlockTrap
 * @notice Triggers when block.number satisfies a Fibonacci-style periodic condition.
 * @dev Uses modulo logic so the trap can actually trigger on modern block heights.
 */
contract FibonacciBlockTrap is ITrap {
    /// @notice Collects deterministic input for Drosera operators
    function collect() external view override returns (bytes memory) {
        return abi.encode(block.number);
    }

    /// @notice Determines whether the responder should be called
    function shouldRespond(
        bytes[] calldata data
    ) external pure override returns (bool, bytes memory) {
        // Planner-safe guard
        if (data.length == 0 || data[0].length == 0) {
            return (false, bytes(""));
        }

        uint256 blockNum = abi.decode(data[0], (uint256));

        /**
         * Fibonacci-style trigger:
         * 55 is a Fibonacci number and creates a predictable, deterministic cadence.
         * This ensures the trap actually fires on live chains.
         */
        if (blockNum % 55 == 0) {
            return (true, abi.encode(blockNum));
        }

        return (false, bytes(""));
    }
}
