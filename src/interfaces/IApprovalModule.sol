// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IApprovalModule {
    event RequestApproved(uint256 indexed requestId, address indexed approver);
    event RequestRejected(uint256 indexed requestId, address indexed approver);

    function approveRequest(uint256 requestId) external;
    function rejectRequest(uint256 requestId) external;
}
