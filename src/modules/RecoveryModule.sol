// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {Types} from "../libraries/Types.sol";
import {IRecoveryModule} from "../interfaces/IRecoveryModule.sol";

contract RecoveryModule is Initializable, AccessControlUpgradeable, IRecoveryModule {
    bytes32 public constant GUARDIAN_ROLE = keccak256("GUARDIAN_ROLE");

    Types.RecoveryState private _recoveryState;
    uint256 public freezeTimestamp;

    error VaultAlreadyFrozen();
    error VaultNotFrozen();
    error OperationNotAllowedInCurrentState();

    function __RecoveryModule_init() internal onlyInitializing {
        __AccessControl_init();
        _recoveryState = Types.RecoveryState.Normal;
    }

    function freezeVault() external onlyRole(GUARDIAN_ROLE) {
        if (_recoveryState == Types.RecoveryState.Frozen) revert VaultAlreadyFrozen();

        _recoveryState = Types.RecoveryState.Frozen;
        freezeTimestamp = block.timestamp;

        emit VaultFrozen(msg.sender);
    }

    function thawVault() external onlyRole(GUARDIAN_ROLE) {
        if (_recoveryState != Types.RecoveryState.Frozen) revert VaultNotFrozen();

        _recoveryState = Types.RecoveryState.Thawed;

        emit VaultThawed(msg.sender);
    }

    function emergencyReturn(uint256 requestId, address safeAddress) external onlyRole(GUARDIAN_ROLE) {
        if (_recoveryState != Types.RecoveryState.Frozen) revert OperationNotAllowedInCurrentState();

        emit EmergencyReturn(requestId, safeAddress);
    }

    function getRecoveryState() public view returns (Types.RecoveryState) {
        return _recoveryState;
    }

    function isOperational() public view returns (bool) {
        return _recoveryState == Types.RecoveryState.Normal || _recoveryState == Types.RecoveryState.Thawed;
    }
}
