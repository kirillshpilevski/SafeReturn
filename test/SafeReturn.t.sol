// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {SafeReturn} from "../src/SafeReturn.sol";
import {ERC1967Proxy} from "openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {Types} from "../src/libraries/Types.sol";

contract MockERC20 {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    function transfer(address to, uint256 amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        return true;
    }

    function mint(address to, uint256 amount) external {
        balanceOf[to] += amount;
    }
}

contract SafeReturnTest is Test {
    SafeReturn public safeReturn;
    MockERC20 public usdc;
    address public owner;
    address public user;

    function setUp() public {
        owner = address(this);
        user = address(0x1);

        usdc = new MockERC20();

        SafeReturn implementation = new SafeReturn();

        bytes memory initData = abi.encodeCall(
            SafeReturn.initialize, (owner, address(usdc), 1 hours, 7 days, 2, 1000 * 1e6)
        );

        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), initData);
        safeReturn = SafeReturn(address(proxy));
    }

    function testInitialization() public view {
        assertEq(safeReturn.minDelay(), 1 hours);
        assertEq(safeReturn.maxDelay(), 7 days);
    }

    function testCreateRequest() public {
        vm.prank(user);
        uint256 requestId = safeReturn.createRequest(address(usdc), 100 * 1e6, 2 hours, "");

        Types.WithdrawalRequest memory request = safeReturn.getRequest(requestId);
        assertEq(request.requester, user);
    }

    function testVersion() public view {
        assertEq(safeReturn.version(), "1.0.0");
    }

    function testApproveRequest() public {
        vm.prank(user);
        uint256 requestId = safeReturn.createRequest(address(usdc), 100 * 1e6, 2 hours, "");

        safeReturn.approveRequest(requestId);
        assertEq(safeReturn.getApprovalCount(requestId), 1);
    }

    function testDepositAndWithdrawal() public {
        usdc.mint(address(this), 1000 * 1e6);
        usdc.approve(address(safeReturn), 1000 * 1e6);

        safeReturn.deposit(address(usdc), 1000 * 1e6);
        assertEq(safeReturn.getBalance(address(usdc)), 1000 * 1e6);
    }

    function testFreezeVault() public {
        safeReturn.freezeVault();
        assertEq(uint256(safeReturn.getRecoveryState()), uint256(Types.RecoveryState.Frozen));
    }
}
