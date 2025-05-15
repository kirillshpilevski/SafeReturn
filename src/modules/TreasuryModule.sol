// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import {IERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import {SafeERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import {ITreasuryModule} from "../interfaces/ITreasuryModule.sol";

contract TreasuryModule is Initializable, ReentrancyGuardUpgradeable, ITreasuryModule {
    using SafeERC20Upgradeable for IERC20Upgradeable;

    mapping(address => uint256) private _balances;
    address public usdcAddress;

    error InsufficientBalance();
    error InvalidAsset();

    function __TreasuryModule_init(address _usdcAddress) internal onlyInitializing {
        __ReentrancyGuard_init();
        usdcAddress = _usdcAddress;
    }

    function deposit(address asset, uint256 amount) external nonReentrant {
        if (asset == address(0)) revert InvalidAsset();

        IERC20Upgradeable(asset).safeTransferFrom(msg.sender, address(this), amount);
        _balances[asset] += amount;

        emit Deposit(asset, amount, msg.sender);
    }

    function getBalance(address asset) external view returns (uint256) {
        return _balances[asset];
    }
}
