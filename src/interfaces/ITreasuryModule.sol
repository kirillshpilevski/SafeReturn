// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITreasuryModule {
    event Deposit(address indexed asset, uint256 amount, address indexed from);
    event Withdrawal(address indexed asset, uint256 amount, address indexed to);
    event ExecutionPrepared(uint256 indexed requestId, address indexed asset, uint256 amount);

    function deposit(address asset, uint256 amount) external;
    function executeWithdrawal(uint256 requestId) external;
    function getBalance(address asset) external view returns (uint256);
}
