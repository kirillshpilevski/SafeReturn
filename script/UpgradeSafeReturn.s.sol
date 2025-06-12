// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {SafeReturn} from "../src/SafeReturn.sol";
import {SafeReturnV2} from "../src/SafeReturnV2.sol";

contract UpgradeSafeReturn is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address proxyAddress = vm.envAddress("PROXY_ADDRESS");

        vm.startBroadcast(deployerPrivateKey);

        SafeReturnV2 newImplementation = new SafeReturnV2();

        SafeReturn proxy = SafeReturn(proxyAddress);
        proxy.upgradeToAndCall(address(newImplementation), abi.encodeCall(SafeReturnV2.initializeV2, (42)));

        vm.stopBroadcast();
    }
}
