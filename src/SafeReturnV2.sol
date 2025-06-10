// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {SafeReturn} from "./SafeReturn.sol";

contract SafeReturnV2 is SafeReturn {
    uint256 public newFeature;

    function initializeV2(uint256 _newFeature) public reinitializer(2) {
        newFeature = _newFeature;
    }

    function version() public pure override returns (string memory) {
        return "2.0.0";
    }
}
