// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {SafeReturn} from "../../src/SafeReturn.sol";
import {ERC1967Proxy} from "openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {Types} from "../../src/libraries/Types.sol";

contract WithdrawalRequestModuleTest is Test {
    SafeReturn public safeReturn;
    address public mockUsdc = address(0x123);
    address public owner = address(this);
    address public user = address(0x1);

    function setUp() public {
        SafeReturn implementation = new SafeReturn();
        bytes memory initData = abi.encodeCall(SafeReturn.initialize, (owner, mockUsdc, 1 hours, 7 days, 2, 1000 * 1e6));
        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), initData);
        safeReturn = SafeReturn(address(proxy));
    }

    function testCancelRequest() public {
        vm.startPrank(user);
        uint256 requestId = safeReturn.createRequest(mockUsdc, 100 * 1e6, 2 hours, "");

        safeReturn.cancelRequest(requestId);

        Types.WithdrawalRequest memory request = safeReturn.getRequest(requestId);
        assertEq(uint256(request.status), uint256(Types.RequestStatus.Cancelled));
        vm.stopPrank();
    }

    function testCannotCancelOthersRequest() public {
        vm.prank(user);
        uint256 requestId = safeReturn.createRequest(mockUsdc, 100 * 1e6, 2 hours, "");

        vm.prank(address(0x2));
        vm.expectRevert();
        safeReturn.cancelRequest(requestId);
    }
}
