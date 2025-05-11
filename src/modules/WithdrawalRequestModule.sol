// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {Types} from "../libraries/Types.sol";

contract WithdrawalRequestModule is Initializable {
    uint256 private _nextRequestId;
    mapping(uint256 => Types.WithdrawalRequest) private _requests;

    uint256 public minDelay;
    uint256 public maxDelay;
}
