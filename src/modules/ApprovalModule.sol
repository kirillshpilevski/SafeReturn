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
}
