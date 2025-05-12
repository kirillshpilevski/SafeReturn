// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {Types} from "../libraries/Types.sol";
import {IWithdrawalRequestModule} from "../interfaces/IWithdrawalRequestModule.sol";

contract WithdrawalRequestModule is Initializable, IWithdrawalRequestModule {
    uint256 private _nextRequestId;
    mapping(uint256 => Types.WithdrawalRequest) private _requests;
    mapping(address => uint256[]) private _userRequests;

    uint256 public minDelay;
    uint256 public maxDelay;

    error InvalidDelay();
    error RequestNotFound();
    error UnauthorizedCancellation();
    error InvalidStatus();

    function __WithdrawalRequestModule_init(uint256 _minDelay, uint256 _maxDelay) internal onlyInitializing {
        minDelay = _minDelay;
        maxDelay = _maxDelay;
        _nextRequestId = 1;
    }

    function createRequest(address asset, uint256 amount, uint256 delay, bytes calldata metadata)
        public
        returns (uint256)
    {
        if (delay < minDelay || delay > maxDelay) revert InvalidDelay();

        uint256 requestId = _nextRequestId++;
        uint256 releaseTimestamp = block.timestamp + delay;

        _requests[requestId] = Types.WithdrawalRequest({
            id: requestId,
            requester: msg.sender,
            asset: asset,
            amount: amount,
            requestTimestamp: block.timestamp,
            releaseTimestamp: releaseTimestamp,
            status: Types.RequestStatus.Pending,
            metadata: metadata
        });

        _userRequests[msg.sender].push(requestId);

        emit WithdrawalRequested(requestId, msg.sender, asset, amount, releaseTimestamp);

        return requestId;
    }

    function cancelRequest(uint256 requestId) external {
        Types.WithdrawalRequest storage request = _requests[requestId];
        if (request.id == 0) revert RequestNotFound();
        if (request.requester != msg.sender) revert UnauthorizedCancellation();
        if (request.status != Types.RequestStatus.Pending) revert InvalidStatus();

        request.status = Types.RequestStatus.Cancelled;

        emit WithdrawalCancelled(requestId);
    }

    function finalizeRequest(uint256 requestId) public {
        Types.WithdrawalRequest storage request = _requests[requestId];
        if (request.id == 0) revert RequestNotFound();
        if (request.status != Types.RequestStatus.Approved) revert InvalidStatus();

        request.status = Types.RequestStatus.Executed;

        emit WithdrawalFinalized(requestId);
    }

    function getRequest(uint256 requestId) public view returns (Types.WithdrawalRequest memory) {
        return _requests[requestId];
    }

    function getUserRequests(address user) external view returns (uint256[] memory) {
        return _userRequests[user];
    }
}
