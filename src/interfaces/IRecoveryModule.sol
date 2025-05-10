// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Types} from "../libraries/Types.sol";

interface IRecoveryModule {
    event VaultFrozen(address indexed guardian);
    event VaultThawed(address indexed guardian);

    function freezeVault() external;
    function thawVault() external;
    function getRecoveryState() external view returns (Types.RecoveryState);
}
