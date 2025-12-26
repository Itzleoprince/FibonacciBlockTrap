// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "drosera-contracts/interfaces/ITrap.sol";

contract FibonacciBlockTrap is ITrap {
    // Precomputed Fibonacci numbers (first 20)
    uint256[20] private fibNumbers = [
        0,
        1,
        1,
        2,
        3,
        5,
        8,
        13,
        21,
        34,
        55,
        89,
        144,
        233,
        377,
        610,
        987,
        1597,
        2584,
        4181
    ];

    function collect() external view returns (bytes memory) {
        return abi.encode(block.number);
    }

    function shouldRespond(
        bytes[] calldata data
    ) external pure returns (bool, bytes memory) {
        if (data.length == 0 || data[0].length == 0) return (false, bytes(""));

        uint256 blockNum = abi.decode(data[0], (uint256));
        uint256[20] memory fib = [
            uint256(0),
            1,
            1,
            2,
            3,
            5,
            8,
            13,
            21,
            34,
            55,
            89,
            144,
            233,
            377,
            610,
            987,
            1597,
            2584,
            4181
        ];

        for (uint i = 0; i < fib.length; i++) {
            if (blockNum == fib[i]) {
                return (true, abi.encode(blockNum));
            }
        }

        return (false, bytes(""));
    }
}
