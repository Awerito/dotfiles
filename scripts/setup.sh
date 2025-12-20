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

# Use sudo only if not root
if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
    CURRENT_USER="root"
else
    SUDO="sudo"
    CURRENT_USER="$(whoami)"
fi

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
    $SUDO apt-get update
    $SUDO apt-get install -y ca-certificates curl gnupg
    $SUDO install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | $SUDO gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    $SUDO chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | $SUDO tee /etc/apt/sources.list.d/docker.list > /dev/null
    $SUDO apt-get update
    $SUDO apt-get install -y docker-ce docker-ce-cli containerd.io
    # Add user to docker group (skip for root)
    if [ "$CURRENT_USER" != "root" ]; then
        $SUDO usermod -aG docker "$CURRENT_USER"
    fi
    print_success "Docker installed"
fi

# ============================================
# PULL BASE IMAGE
# ============================================
print_step "Pulling pre-built base image..."
$SUDO docker pull "$BASE_IMAGE"
print_success "Base image ready"

# ============================================
# EXTRACT PRE-BUILT TOOLS
# ============================================
print_step "Extracting pre-built tools..."
$SUDO docker create --name "$CONTAINER_NAME" "$BASE_IMAGE"

# Neovim
$SUDO docker cp "$CONTAINER_NAME:/usr/local/bin/nvim" /usr/local/bin/
$SUDO docker cp "$CONTAINER_NAME:/usr/local/lib/nvim" /usr/local/lib/
$SUDO docker cp "$CONTAINER_NAME:/usr/local/share/nvim" /usr/local/share/
print_success "Neovim installed"

# Oh My Zsh
$SUDO docker cp "$CONTAINER_NAME:/root/.oh-my-zsh" "$HOME/.oh-my-zsh"
if [ "$CURRENT_USER" != "root" ]; then
    $SUDO chown -R "$CURRENT_USER:$CURRENT_USER" "$HOME/.oh-my-zsh"
fi
print_success "Oh My Zsh installed"

# NVM + Node
$SUDO docker cp "$CONTAINER_NAME:/root/.nvm" "$HOME/.nvm"
if [ "$CURRENT_USER" != "root" ]; then
    $SUDO chown -R "$CURRENT_USER:$CURRENT_USER" "$HOME/.nvm"
fi
print_success "NVM + Node installed"

# Kitty
mkdir -p "$HOME/.local"
$SUDO docker cp "$CONTAINER_NAME:/root/.local/kitty.app" "$HOME/.local/kitty.app"
if [ "$CURRENT_USER" != "root" ]; then
    $SUDO chown -R "$CURRENT_USER:$CURRENT_USER" "$HOME/.local/kitty.app"
fi
$SUDO ln -sf "$HOME/.local/kitty.app/bin/kitty" /usr/local/bin/
$SUDO ln -sf "$HOME/.local/kitty.app/bin/kitten" /usr/local/bin/
mkdir -p "$HOME/.local/share/applications"
if [ -f "$HOME/.local/kitty.app/share/applications/kitty.desktop" ]; then
    cp "$HOME/.local/kitty.app/share/applications/kitty.desktop" "$HOME/.local/share/applications/"
    sed -i "s|Icon=kitty|Icon=$HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" "$HOME/.local/share/applications/kitty.desktop"
fi
print_success "Kitty terminal installed"

# Nerd Fonts
mkdir -p "$HOME/.local/share/fonts"
$SUDO docker cp "$CONTAINER_NAME:/root/.local/share/fonts/." "$HOME/.local/share/fonts/"
if [ "$CURRENT_USER" != "root" ]; then
    $SUDO chown -R "$CURRENT_USER:$CURRENT_USER" "$HOME/.local/share/fonts"
fi
print_success "Nerd Fonts installed"

# Cleanup container
$SUDO docker rm "$CONTAINER_NAME" > /dev/null
print_success "Cleanup done"

# ============================================
# INSTALL SYSTEM PACKAGES
# ============================================
print_step "Installing system packages..."
$SUDO apt-get update
$SUDO apt-get install -y git curl wget stow zsh xclip ripgrep fd-find fzf tree unzip 7zip htop fontconfig python3-pip python3-venv
print_success "System packages installed"

# Rebuild font cache now that fontconfig is installed
fc-cache -fv > /dev/null 2>&1 || true

# ============================================
# INSTALL FASTFETCH (needs PPA)
# ============================================
if ! command -v fastfetch &> /dev/null; then
    print_step "Installing Fastfetch..."
    $SUDO apt-get install -y software-properties-common
    $SUDO add-apt-repository ppa:zhangsongcui3371/fastfetch -y
    $SUDO apt-get update
    $SUDO apt-get install -y fastfetch
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
    $SUDO chsh -s "$(which zsh)" "$CURRENT_USER"
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
