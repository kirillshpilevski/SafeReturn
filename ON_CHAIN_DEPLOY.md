# 🚀 On-Chain Deployment Guide

## 📋 Prerequisites

### 1. Get Base Sepolia ETH (for testnet)
```bash
# Visit Base Sepolia faucet:
https://www.coinbase.com/faucets/base-ethereum-goerli-faucet

# Or bridge from Sepolia:
https://bridge.base.org
```

### 2. Get Basescan API Key (optional, for verification)
```bash
# Visit Basescan:
https://basescan.org/myapikey

# Create account and generate API key
```

## ⚙️ Setup GitHub Secrets

### Go to GitHub Repository Settings:
```
https://github.com/kirillshpilevski/SafeReturn/settings/secrets/actions
```

### Add these secrets:

1. **PRIVATE_KEY**
   - Your wallet private key (with 0x prefix)
   - Must have ETH on Base Sepolia

2. **BASESCAN_API_KEY**
   - Your Basescan API key
   - For contract verification

## 🎯 Deploy via GitHub Actions

### Method 1: Via GitHub UI (Easiest)

1. Go to Actions tab:
   ```
   https://github.com/kirillshpilevski/SafeReturn/actions
   ```

2. Click **"Deploy SafeReturn"** workflow

3. Click **"Run workflow"** button

4. Select network:
   - `base-sepolia` (recommended for testing)
   - `base` (mainnet - be careful!)

5. Click **"Run workflow"**

6. Wait ~2-3 minutes for deployment

7. Download artifacts to see deployed addresses

### Method 2: Via GitHub CLI (Advanced)

```bash
# Install gh CLI
brew install gh  # or: https://cli.github.com/

# Login
gh auth login

# Trigger deployment to Base Sepolia
gh workflow run "Deploy SafeReturn" \
  --repo kirillshpilevski/SafeReturn \
  --field network=base-sepolia

# Check status
gh run list --repo kirillshpilevski/SafeReturn
```

## 📦 After Deployment

### 1. Check deployment artifacts
- Download from Actions run
- Find `broadcast/` folder
- Get proxy and implementation addresses

### 2. Verify on Basescan
```
https://sepolia.basescan.org/address/YOUR_PROXY_ADDRESS
```

### 3. Interact with contract
```bash
# Using cast
export PROXY_ADDRESS=0x...

# Check version
cast call $PROXY_ADDRESS "version()(string)" --rpc-url base-sepolia

# Get system status
cast call $PROXY_ADDRESS "getSystemStatus()(uint8,uint256,uint256)" --rpc-url base-sepolia
```

## 🎮 Test On-Chain

### Create withdrawal request:
```bash
cast send $PROXY_ADDRESS \
  "createRequest(address,uint256,uint256,bytes)(uint256)" \
  0x036CbD53842c5426634e7929541eC2318f3dCF7e \
  1000000 \
  7200 \
  0x \
  --private-key $PRIVATE_KEY \
  --rpc-url base-sepolia
```

### Approve request:
```bash
cast send $PROXY_ADDRESS \
  "approveRequest(uint256)" \
  1 \
  --private-key $PRIVATE_KEY \
  --rpc-url base-sepolia
```

### Freeze vault (emergency):
```bash
cast send $PROXY_ADDRESS \
  "freezeVault()" \
  --private-key $PRIVATE_KEY \
  --rpc-url base-sepolia
```

## 🔍 Monitor

- **Basescan**: https://sepolia.basescan.org/
- **Base Explorer**: https://sepolia-explorer.base.org/
- **Transaction logs**: Check GitHub Actions artifacts

## ⚠️ Important Notes

- **Always test on Sepolia first!**
- Deployment cost: ~0.01-0.05 ETH (Sepolia)
- Verification takes 30-60 seconds
- Save proxy address - it's permanent!

## 🆘 Troubleshooting

### "Insufficient funds"
- Get more Sepolia ETH from faucet

### "Verification failed"
- Check BASESCAN_API_KEY is correct
- Wait 1 minute and try manual verification

### "RPC error"
- Base RPC might be slow
- Retry after 1 minute

## 📊 Expected Output

```
✅ Implementation deployed: 0x1234...
✅ Proxy deployed: 0x5678...
✅ Verified on Basescan
✅ Version: 1.0.0
```

Ready to deploy! 🎉
