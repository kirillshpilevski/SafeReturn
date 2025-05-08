// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IApprovalModule {
    event RequestApproved(uint256 indexed requestId, address indexed approver);
    event RequestRejected(uint256 indexed requestId, address indexed approver);
    event ThresholdUpdated(uint256 newThreshold);
    event FastTrackLimitUpdated(uint256 newLimit);

    function approveRequest(uint256 requestId) external;
    function rejectRequest(uint256 requestId) external;
    function isApproved(uint256 requestId) external view returns (bool);
    function getApprovalCount(uint256 requestId) external view returns (uint256);
}
