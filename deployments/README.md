# Deployments

This directory contains deployment information for SafeReturn contracts across different networks.

## Base Sepolia (Testnet)

- **Proxy Contract**: [`0x24766824e574A438C9c3BFf370755B627e600B3E`](https://sepolia.basescan.org/address/0x24766824e574a438c9c3bff370755b627e600b3e)
- **Implementation**: [`0xA74062ae0B7A071627130b1A0C543B411982b5bD`](https://sepolia.basescan.org/address/0xa74062ae0b7a071627130b1a0c543b411982b5bd)
- **Status**: ✅ Verified
- **USDC Address**: `0x036CbD53842c5426634e7929541eC2318f3dCF7e`

## Configuration

- **Min Delay**: 1 hour (3600 seconds)
- **Max Delay**: 7 days (604800 seconds)
- **Approval Threshold**: 2 approvers
- **Fast Track Limit**: 1000 USDC

## Testing On-Chain

### Check contract version:
```bash
cast call 0x24766824e574A438C9c3BFf370755B627e600B3E "version()(string)" --rpc-url base-sepolia
```

### Create withdrawal request:
```bash
cast send 0x24766824e574A438C9c3BFf370755B627e600B3E \
  "createRequest(address,uint256,bytes)" \
  0x036CbD53842c5426634e7929541eC2318f3dCF7e \
  1000000000 \
  0x \
  --rpc-url base-sepolia \
  --private-key $PRIVATE_KEY
```

### Approve request:
```bash
cast send 0x24766824e574A438C9c3BFf370755B627e600B3E \
  "approveRequest(uint256)" \
  0 \
  --rpc-url base-sepolia \
  --private-key $PRIVATE_KEY
```

### Check if operational:
```bash
cast call 0x24766824e574A438C9c3BFf370755B627e600B3E "isOperational()(bool)" --rpc-url base-sepolia
```

### Freeze vault (emergency):
```bash
cast send 0x24766824e574A438C9c3BFf370755B627e600B3E \
  "freezeVault()" \
  --rpc-url base-sepolia \
  --private-key $PRIVATE_KEY
```
