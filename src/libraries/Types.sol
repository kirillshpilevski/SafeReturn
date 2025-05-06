// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library Types {
    enum RequestStatus {
        Pending,
        Approved,
        Executed,
        Cancelled
    }

    enum RecoveryState {
        Normal,
        Frozen,
        Thawed
    }

    struct WithdrawalRequest {
        uint256 id;
        address requester;
        address asset;
        uint256 amount;
        uint256 requestTimestamp;
        uint256 releaseTimestamp;
        RequestStatus status;
        bytes metadata;
    }
}
