# Deployment Setup Guide

This guide explains how to set up automated deployment for the Subaru VS Code theme to both the Visual Studio Marketplace and Open VSX Registry.

## Prerequisites

Before you can use the automated deployment, you need to set up the following:

### 1. Visual Studio Marketplace (VSCE) Personal Access Token

1. Go to [Azure DevOps](https://dev.azure.com/)
2. Sign in with your Microsoft account
3. Click on your profile picture → "Personal Access Tokens"
4. Click "New Token"
5. Configure the token:
   - **Name**: `VS Code Extension Publishing`
   - **Organization**: Select "All accessible organizations"
   - **Expiration**: Set to your preference (90 days recommended)
   - **Scopes**: Select "Custom defined" and check **Marketplace → Manage**
6. Click "Create" and copy the token

### 2. Open VSX Registry Personal Access Token

1. Go to [Open VSX Registry](https://open-vsx.org/)
2. Sign in with your GitHub account
3. Go to your profile → "Access Tokens"
4. Click "Create new access token"
5. Give it a name like `Subaru Theme Publishing`
6. Click "Create" and copy the token

### 3. Publisher Account Setup

#### Visual Studio Marketplace

1. Go to [Visual Studio Marketplace Manage](https://marketplace.visualstudio.com/manage)
2. Create a publisher account if you don't have one
3. Make sure your publisher ID matches the one in `package.json` (`fellipeutaka`)

#### Open VSX Registry

1. Your GitHub account can publish extensions
2. No additional setup required

## GitHub Repository Setup

### 1. Add Repository Secrets

Go to your GitHub repository → Settings → Secrets and variables → Actions, then add:

- **`VSCE_PAT`**: Your Visual Studio Marketplace Personal Access Token
- **`OVSX_PAT`**: Your Open VSX Registry Personal Access Token

### 2. Deployment Methods

The workflow supports two deployment methods:

#### Method 1: Tag-based Deployment (Recommended)

```bash
# Create and push a version tag
git tag v1.0.4
git push origin v1.0.4
```

#### Method 2: Manual Deployment

1. Go to your repository → Actions
2. Select "Deploy VS Code Extension" workflow
3. Click "Run workflow"
4. Enter the version number (e.g., `1.0.4`)
5. Click "Run workflow"

## What the Workflow Does

1. **Triggers** on version tags (`v*.*.*`) or manual dispatch
2. **Updates** the version in `package.json`
3. **Packages** the extension using `vsce`
4. **Publishes** to Visual Studio Marketplace
5. **Publishes** to Open VSX Registry
6. **Creates** a GitHub release with the `.vsix` file
7. **Uploads** the extension as a build artifact

## Version Management

The workflow automatically handles version management:

- For tag-based deployments: Uses the tag version (e.g., `v1.0.4` → `1.0.4`)
- For manual deployments: Uses the version you specify in the workflow input

## Troubleshooting

### Common Issues

1. **Publisher not found**: Make sure your publisher account exists and the ID matches `package.json`
2. **Token expired**: Regenerate your PAT tokens and update the repository secrets
3. **Version already exists**: Use a new version number that hasn't been published

### Checking Deployment Status

- **Visual Studio Marketplace**: [Manage Extensions](https://marketplace.visualstudio.com/manage)
- **Open VSX**: [Your Extensions](https://open-vsx.org/user-settings/extensions)
- **GitHub Releases**: Check your repository's releases page

## Security Notes

- Never commit PAT tokens to your repository
- Use repository secrets to store sensitive information
- Regularly rotate your PAT tokens for security
- The workflow only runs on the main branch for security

## Example Deployment

```bash
# Current version in package.json: 0.0.3
# To deploy version 1.0.0:

git tag v1.0.0
git push origin v1.0.0

# The workflow will:
# 1. Update package.json to version 1.0.0
# 2. Package and publish the extension
# 3. Create a GitHub release
```
