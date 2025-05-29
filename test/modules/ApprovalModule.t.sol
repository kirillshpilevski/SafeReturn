// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {SafeReturn} from "../../src/SafeReturn.sol";
import {ERC1967Proxy} from "openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract ApprovalModuleTest is Test {
    SafeReturn public safeReturn;
    address public mockUsdc = address(0x123);
    address public owner = address(this);
    address public user = address(0x1);

    function setUp() public {
        SafeReturn implementation = new SafeReturn();
        bytes memory initData =
            abi.encodeCall(SafeReturn.initialize, (owner, mockUsdc, 1 hours, 7 days, 2, 1000 * 1e6));
        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), initData);
        safeReturn = SafeReturn(address(proxy));
    }

    function testFastTrackLogic() public view {
        assertTrue(safeReturn.canFastTrack(500 * 1e6));
        assertFalse(safeReturn.canFastTrack(1500 * 1e6));
    }

    function testUpdateThreshold() public {
        safeReturn.updateThreshold(3);
        assertEq(safeReturn.approvalThreshold(), 3);
    }
}
