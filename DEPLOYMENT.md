# Deployment Guide

## Prerequisites

- Foundry installed
- Private key with ETH for gas
- Basescan API key

## Deploy to Base Sepolia

```bash
forge script script/DeploySafeReturn.s.sol \
  --rpc-url base-sepolia \
  --broadcast
```

## Configuration

Default parameters:
- Min delay: 1 hour
- Max delay: 7 days
- Approval threshold: 2
- Fast-track limit: 1000 USDC
