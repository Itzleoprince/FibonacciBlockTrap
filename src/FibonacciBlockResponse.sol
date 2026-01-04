// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title FibonacciBlockResponse
 * @notice Simple responder that emits an event when triggered by Drosera
 */
contract FibonacciBlockResponse {
    event FibonacciBlock(uint256 blockNumber);

    function respondWithFibonacci(uint256 blockNumber) external {
        emit FibonacciBlock(blockNumber);
    }
}
