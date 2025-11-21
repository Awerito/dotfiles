#!/bin/bash

# ============================================
# One-liner installer for dotfiles
# Quick setup script that clones and runs main setup
# ============================================

set -e

# Configuration - UPDATE THIS WITH YOUR REPO URL
DOTFILES_REPO="https://github.com/Awerito/dotfiles.git"  # Replace with your GitHub/GitLab URL
DOTFILES_DIR="$HOME/.dotfiles"

# Color codes for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}       Dotfiles Installation Script${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# Ensure git is available
if ! command -v git >/dev/null 2>&1; then
    echo -e "${YELLOW}Git is not installed. Installing...${NC}"
    sudo apt update
    sudo apt install -y git
    echo -e "${GREEN}✓ Git installed${NC}"
fi

# Handle existing dotfiles directory
if [ -d "$DOTFILES_DIR" ]; then
    echo -e "${YELLOW}⚠ Dotfiles directory already exists at $DOTFILES_DIR${NC}"
    echo -e "${YELLOW}Do you want to remove it and clone fresh? (y/N)${NC}"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Backing up existing dotfiles...${NC}"
        mv "$DOTFILES_DIR" "${DOTFILES_DIR}_backup_$(date +%Y%m%d_%H%M%S)"
    else
        echo -e "${RED}Installation cancelled.${NC}"
        exit 1
    fi
fi

# Clone dotfiles repository
echo -e "${BLUE}==> Cloning dotfiles repository...${NC}"
git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
echo -e "${GREEN}✓ Repository cloned${NC}"

# Execute main setup script
echo ""
echo -e "${BLUE}==> Running setup script...${NC}"
cd "$DOTFILES_DIR"
chmod +x scripts/setup.sh
./scripts/setup.sh

echo ""
echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}✓ Installation complete!${NC}"
echo -e "${GREEN}================================================${NC}"
