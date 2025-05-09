// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITreasuryModule {
    event Deposit(address indexed asset, uint256 amount, address indexed from);
    event Withdrawal(address indexed asset, uint256 amount, address indexed to);

    function deposit(address asset, uint256 amount) external;
    function getBalance(address asset) external view returns (uint256);
}
