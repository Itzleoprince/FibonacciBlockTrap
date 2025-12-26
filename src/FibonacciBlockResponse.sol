// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract FibonacciBlockResponse {
    event FibonacciBlock(uint256 blockNumber);

    function respondWithFibonacci(uint256 blockNumber) external {
        emit FibonacciBlock(blockNumber);
    }
}
