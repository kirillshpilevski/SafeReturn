// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Types} from "../libraries/Types.sol";

interface IRecoveryModule {
    event VaultFrozen(address indexed guardian);
    event VaultThawed(address indexed guardian);
    event EmergencyReturn(uint256 indexed requestId, address indexed safeAddress);

    function freezeVault() external;
    function thawVault() external;
    function emergencyReturn(uint256 requestId, address safeAddress) external;
    function getRecoveryState() external view returns (Types.RecoveryState);
}
