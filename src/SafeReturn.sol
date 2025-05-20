// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {WithdrawalRequestModule} from "./modules/WithdrawalRequestModule.sol";
import {ApprovalModule} from "./modules/ApprovalModule.sol";
import {TreasuryModule} from "./modules/TreasuryModule.sol";
import {RecoveryModule} from "./modules/RecoveryModule.sol";
import {Types} from "./libraries/Types.sol";

contract SafeReturn is
    Initializable,
    UUPSUpgradeable,
    OwnableUpgradeable,
    WithdrawalRequestModule,
    ApprovalModule,
    TreasuryModule,
    RecoveryModule
{
    bytes32 public constant EXECUTOR_ROLE = keccak256("EXECUTOR_ROLE");

    error WithdrawalNotReady();
    error VaultCurrentlyFrozen();

    constructor() {
        _disableInitializers();
    }

    function initialize(
        address owner,
        address usdcAddress,
        uint256 minDelay,
        uint256 maxDelay,
        uint256 approvalThreshold,
        uint256 fastTrackLimit
    ) public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();
        __WithdrawalRequestModule_init(minDelay, maxDelay);
        __ApprovalModule_init(approvalThreshold, fastTrackLimit);
        __TreasuryModule_init(usdcAddress);
        __RecoveryModule_init();

        transferOwnership(owner);
        _grantRole(DEFAULT_ADMIN_ROLE, owner);
        _grantRole(ADMIN_ROLE, owner);
        _grantRole(GUARDIAN_ROLE, owner);
        _grantRole(EXECUTOR_ROLE, owner);
    }

    function executeApprovedWithdrawal(uint256 requestId) external onlyRole(EXECUTOR_ROLE) {
        Types.WithdrawalRequest memory request = getRequest(requestId);

        if (request.status != Types.RequestStatus.Approved) revert WithdrawalNotReady();
        if (block.timestamp < request.releaseTimestamp) revert WithdrawalNotReady();
        if (!isOperational()) revert VaultCurrentlyFrozen();

        finalizeRequest(requestId);
        _executeTransfer(request.asset, request.requester, request.amount);
    }

    function createAndApproveRequest(address asset, uint256 amount, uint256 delay, bytes calldata metadata)
        external
        onlyRole(ADMIN_ROLE)
        returns (uint256)
    {
        uint256 requestId = createRequest(asset, amount, delay, metadata);

        if (canFastTrack(amount)) {
            approveRequest(requestId);
        }

        return requestId;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function version() public pure virtual returns (string memory) {
        return "1.0.0";
    }
}
