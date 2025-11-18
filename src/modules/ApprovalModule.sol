// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {Types} from "../libraries/Types.sol";
import {IApprovalModule} from "../interfaces/IApprovalModule.sol";

contract ApprovalModule is Initializable, AccessControlUpgradeable, IApprovalModule {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    mapping(uint256 => mapping(address => Types.Approval)) private _approvals;
    mapping(uint256 => uint256) private _approvalCounts;

    uint256 public approvalThreshold;
    uint256 public fastTrackLimit;

    error AlreadyApproved();

    function __ApprovalModule_init(uint256 _threshold, uint256 _fastTrackLimit) internal onlyInitializing {
        __AccessControl_init();
        approvalThreshold = _threshold;
        fastTrackLimit = _fastTrackLimit;
    }

    function approveRequest(uint256 requestId) public onlyRole(ADMIN_ROLE) {
        if (_approvals[requestId][msg.sender].approved) revert AlreadyApproved();

        _approvals[requestId][msg.sender] = Types.Approval({
            approver: msg.sender,
            timestamp: block.timestamp,
            approved: true
        });

        _approvalCounts[requestId]++;

        emit RequestApproved(requestId, msg.sender);
    }

    function rejectRequest(uint256 requestId) external onlyRole(ADMIN_ROLE) {
        _approvals[requestId][msg.sender] = Types.Approval({
            approver: msg.sender,
            timestamp: block.timestamp,
            approved: false
        });

        emit RequestRejected(requestId, msg.sender);
    }

    function isApproved(uint256 requestId) external view returns (bool) {
        return _approvalCounts[requestId] >= approvalThreshold;
    }

    function canFastTrack(uint256 amount) public view returns (bool) {
        return amount <= fastTrackLimit;
    }

    function getApprovalCount(uint256 requestId) external view returns (uint256) {
        return _approvalCounts[requestId];
    }

    function updateThreshold(uint256 newThreshold) external onlyRole(DEFAULT_ADMIN_ROLE) {
        approvalThreshold = newThreshold;
        emit ThresholdUpdated(newThreshold);
    }

    function updateFastTrackLimit(uint256 newLimit) external onlyRole(DEFAULT_ADMIN_ROLE) {
        fastTrackLimit = newLimit;
        emit FastTrackLimitUpdated(newLimit);
    }
}
