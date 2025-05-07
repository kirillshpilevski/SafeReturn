// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Types} from "../libraries/Types.sol";

interface IWithdrawalRequestModule {
    event WithdrawalRequested(
        uint256 indexed requestId,
        address indexed requester,
        address indexed asset,
        uint256 amount,
        uint256 releaseTimestamp
    );

    function createRequest(address asset, uint256 amount, uint256 delay, bytes calldata metadata)
        external
        returns (uint256);
}
