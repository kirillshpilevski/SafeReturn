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

    function __WithdrawalRequestModule_init(uint256 _minDelay, uint256 _maxDelay) internal onlyInitializing {
        minDelay = _minDelay;
        maxDelay = _maxDelay;
        _nextRequestId = 1;
    }
}
