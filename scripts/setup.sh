#!/bin/bash

# ============================================
# Dotfiles Setup Script
# "From zero to hero" - User no thinks
# ============================================

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_step() { echo -e "${BLUE}==>${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }

# Config
DOTFILES_REPO="https://github.com/Awerito/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"
BASE_IMAGE="ghcr.io/awerito/dotfiles-base:latest"
CONTAINER_NAME="dotfiles-tmp-$$"

# ============================================
# INSTALL DOCKER
# ============================================
if ! command -v docker &> /dev/null; then
    print_step "Installing Docker..."
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo usermod -aG docker "$USER"
    print_success "Docker installed"
fi

# ============================================
# PULL BASE IMAGE
# ============================================
print_step "Pulling pre-built base image..."
sudo docker pull "$BASE_IMAGE"
print_success "Base image ready"

# ============================================
# EXTRACT PRE-BUILT TOOLS
# ============================================
print_step "Extracting pre-built tools..."
sudo docker create --name "$CONTAINER_NAME" "$BASE_IMAGE"

# Neovim
sudo docker cp "$CONTAINER_NAME:/usr/local/bin/nvim" /usr/local/bin/
sudo docker cp "$CONTAINER_NAME:/usr/local/lib/nvim" /usr/local/lib/
sudo docker cp "$CONTAINER_NAME:/usr/local/share/nvim" /usr/local/share/
print_success "Neovim installed"

# Oh My Zsh
docker cp "$CONTAINER_NAME:/root/.oh-my-zsh" "$HOME/.oh-my-zsh"
print_success "Oh My Zsh installed"

# NVM + Node
docker cp "$CONTAINER_NAME:/root/.nvm" "$HOME/.nvm"
print_success "NVM + Node installed"

# Kitty
mkdir -p "$HOME/.local"
docker cp "$CONTAINER_NAME:/root/.local/kitty.app" "$HOME/.local/kitty.app"
sudo ln -sf "$HOME/.local/kitty.app/bin/kitty" /usr/local/bin/
sudo ln -sf "$HOME/.local/kitty.app/bin/kitten" /usr/local/bin/
mkdir -p "$HOME/.local/share/applications"
cp "$HOME/.local/kitty.app/share/applications/kitty.desktop" "$HOME/.local/share/applications/"
sed -i "s|Icon=kitty|Icon=$HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" "$HOME/.local/share/applications/kitty.desktop"
print_success "Kitty terminal installed"

# Nerd Fonts
mkdir -p "$HOME/.local/share/fonts"
docker cp "$CONTAINER_NAME:/root/.local/share/fonts/." "$HOME/.local/share/fonts/"
fc-cache -fv > /dev/null 2>&1
print_success "Nerd Fonts installed"

# Cleanup container
sudo docker rm "$CONTAINER_NAME" > /dev/null
print_success "Cleanup done"

# ============================================
# INSTALL SYSTEM PACKAGES
# ============================================
print_step "Installing system packages..."
sudo apt-get update
sudo apt-get install -y git curl wget stow zsh xclip ripgrep fd-find fzf tree unzip 7zip htop fontconfig python3-pip python3-venv
print_success "System packages installed"

# ============================================
# INSTALL FASTFETCH (needs PPA)
# ============================================
if ! command -v fastfetch &> /dev/null; then
    print_step "Installing Fastfetch..."
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository ppa:zhangsongcui3371/fastfetch -y
    sudo apt-get update
    sudo apt-get install -y fastfetch
    print_success "Fastfetch installed"
fi

# ============================================
# CLONE DOTFILES
# ============================================
if [ ! -d "$DOTFILES_DIR" ]; then
    print_step "Cloning dotfiles..."
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    print_success "Dotfiles cloned"
else
    print_success "Dotfiles already exist"
fi

# ============================================
# APPLY DOTFILES WITH STOW
# ============================================
print_step "Applying dotfiles..."

# Backup existing .zshrc
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    mv "$HOME/.zshrc" "$BACKUP_DIR/"
    print_warning "Backed up .zshrc to $BACKUP_DIR"
fi

cd "$DOTFILES_DIR" && stow --adopt .
print_success "Dotfiles applied"

# ============================================
# SET DEFAULT SHELL
# ============================================
if [ "$SHELL" != "$(which zsh)" ]; then
    print_step "Setting Zsh as default shell..."
    sudo chsh -s "$(which zsh)" "$(whoami)"
    print_success "Default shell changed to Zsh"
fi

# ============================================
# DONE
# ============================================
echo ""
echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}✓ Setup completed!${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Restart terminal or run: ${BLUE}exec zsh${NC}"
echo -e "  2. Open Neovim to install plugins: ${BLUE}nvim${NC}"
echo ""
