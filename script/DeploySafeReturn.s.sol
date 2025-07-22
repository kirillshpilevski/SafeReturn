// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {SafeReturn} from "../src/SafeReturn.sol";
import {ERC1967Proxy} from "openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeploySafeReturn is Script {
    function run() external returns (address proxy, address implementation) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        address usdcAddress = getUSDCAddress();

        uint256 minDelay = 1 hours;
        uint256 maxDelay = 7 days;
        uint256 approvalThreshold = 2;
        uint256 fastTrackLimit = 1000 * 1e6;

        vm.startBroadcast(deployerPrivateKey);

        implementation = address(new SafeReturn());

        bytes memory initData = abi.encodeCall(
            SafeReturn.initialize, (deployer, usdcAddress, minDelay, maxDelay, approvalThreshold, fastTrackLimit)
        );

        proxy = address(new ERC1967Proxy(implementation, initData));

        vm.stopBroadcast();

        return (proxy, implementation);
    }

    function getUSDCAddress() internal view returns (address) {
        if (block.chainid == 8453) {
            return 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913;
        } else if (block.chainid == 84532) {
            return 0x036CbD53842c5426634e7929541eC2318f3dCF7e;
        } else {
            revert("Unsupported chain");
        }
    }
}
