# SafeReturn

Secure, upgradeable asset-recovery and controlled withdrawal system for Base network.

## Overview

SafeReturn provides a trustworthy, governance-aware mechanism for managing protected funds, delayed withdrawals, automated recovery logic, and USDC payouts through Base Pay integration.

## Architecture

### Core Modules

- **WithdrawalRequestModule**: Request management with timelock mechanics
- **ApprovalModule**: Multi-role approval system with threshold-based logic
- **TreasuryModule**: USDC vault with Base Pay integration
- **RecoveryModule**: Emergency freeze/thaw state machine
- **UpgradeModule**: UUPS upgradeable pattern for long-term maintainability

### Roles

- **Owner**: Contract owner with upgrade rights
- **Admin**: Can approve requests and manage thresholds
- **Guardian**: Emergency recovery and vault freeze capabilities
- **Executor**: Execute approved withdrawals

## Development

```bash
forge build
forge test
```

## Deployment

```bash
forge script script/DeploySafeReturn.s.sol --rpc-url base-sepolia --broadcast
```

## Features

- Timelock-protected withdrawals
- Multi-signature approval system
- Fast-track mode for small amounts
- Emergency vault freeze
- UUPS upgradeable proxies
- Base network optimized

## Deployed Contracts

### Base Sepolia (Testnet)

- **Proxy**: [`0x24766824e574A438C9c3BFf370755B627e600B3E`](https://sepolia.basescan.org/address/0x24766824e574a438c9c3bff370755b627e600b3e)
- **Implementation**: [`0xA74062ae0B7A071627130b1A0C543B411982b5bD`](https://sepolia.basescan.org/address/0xa74062ae0b7a071627130b1a0c543b411982b5bd)
- **Status**: ✅ Verified

See [deployments](./deployments) directory for detailed configuration and testing commands.

## Testing

```bash
forge test -vv
```

## Security

All contracts upgradeable using UUPS with strict access controls.

## License

MIT
