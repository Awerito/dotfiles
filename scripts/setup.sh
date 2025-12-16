#!/bin/bash

# ============================================
# Dotfiles Setup Script
# Ubuntu-based systems (Debian, Pop!_OS, etc.)
# ============================================

# Parse command line arguments
DRY_RUN=false
if [[ "$1" == "--dry-run" ]] || [[ "$1" == "--test" ]]; then
    DRY_RUN=true
    echo "🔍 DRY RUN MODE - No changes will be made"
    echo ""
fi

set -e  # Exit on error

# Color codes for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions for colored output
print_step() {
    if [ "$DRY_RUN" = true ]; then
        echo -e "${BLUE}[DRY RUN]${NC} Would execute: $1"
    else
        echo -e "${BLUE}==>${NC} $1"
    fi
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Command wrapper that respects dry-run mode
run_command() {
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}  [SKIP]${NC} $*"
        return 0
    else
        eval "$@"
    fi
}

# ============================================
# SYSTEM UPDATE
# ============================================
print_step "Updating system packages..."
run_command "sudo apt update && sudo apt upgrade -y"
print_success "System updated"

# ============================================
# ESSENTIAL PACKAGES
# ============================================
print_step "Installing essential packages..."
run_command "sudo apt install -y git curl wget stow build-essential xclip ripgrep fd-find fzf tree unzip 7zip htop"
print_success "Essential packages installed"

# ============================================
# ZSH SHELL
# ============================================
if ! command_exists zsh; then
    print_step "Installing Zsh..."
    run_command "sudo apt install -y zsh"
    print_success "Zsh installed"
else
    print_success "Zsh already installed"
fi

# Install Oh My Zsh framework
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_step "Installing Oh My Zsh..."
    run_command 'CHSH=no RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
    print_success "Oh My Zsh installed"
else
    print_success "Oh My Zsh already installed"
fi

# ============================================
# NEOVIM TEXT EDITOR (from source)
# ============================================
if ! command_exists nvim; then
    print_step "Installing Neovim from source..."
    # Install build dependencies
    run_command "sudo apt install -y ninja-build gettext cmake curl build-essential"
    # Clone and build
    run_command "git clone --depth 1 --branch stable https://github.com/neovim/neovim.git /tmp/neovim"
    run_command "make -C /tmp/neovim CMAKE_BUILD_TYPE=Release"
    run_command "sudo make -C /tmp/neovim install"
    run_command "rm -rf /tmp/neovim"
    print_success "Neovim installed"
else
    print_success "Neovim already installed"
fi

# ============================================
# NODE.JS RUNTIME (via NVM)
# ============================================
if [ ! -d "$HOME/.nvm" ]; then
    print_step "Installing NVM (Node Version Manager)..."
    run_command 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash'

    # Load NVM into current shell
    if [ "$DRY_RUN" = false ]; then
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi

    print_success "NVM installed"
else
    print_success "NVM already installed"
    if [ "$DRY_RUN" = false ]; then
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi
fi

# Install Node.js LTS version
if ! command_exists node; then
    print_step "Installing Node.js LTS..."
    run_command "nvm install --lts"
    run_command "nvm use --lts"
    print_success "Node.js installed"
else
    print_success "Node.js already installed ($(node --version))"
fi

# Install Claude Code CLI globally via npm
if ! command_exists claude-code; then
    print_step "Installing Claude Code CLI..."
    run_command "npm install -g @anthropic-ai/claude-code"
    print_success "Claude Code CLI installed"
else
    print_success "Claude Code CLI already installed"
fi

# ============================================
# KITTY TERMINAL EMULATOR
# ============================================
if ! command_exists kitty; then
    print_step "Installing Kitty terminal..."
    # Install via official installer
    run_command 'curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin'
    # Create system-wide symbolic links
    run_command "sudo ln -sf ~/.local/kitty.app/bin/kitty /usr/local/bin/"
    run_command "sudo ln -sf ~/.local/kitty.app/bin/kitten /usr/local/bin/"
    # Add desktop integration
    run_command "mkdir -p ~/.local/share/applications"
    run_command "cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/"
    run_command 'sed -i "s|Icon=kitty|Icon=$HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty.desktop'
    print_success "Kitty terminal installed"
else
    print_success "Kitty terminal already installed"
fi

# ============================================
# FASTFETCH (System Information Tool)
# ============================================
if ! command_exists fastfetch; then
    print_step "Installing Fastfetch..."
    # Install software-properties-common for add-apt-repository
    run_command "sudo apt install -y software-properties-common"
    # Add PPA repository
    run_command "sudo add-apt-repository ppa:zhangsongcui3371/fastfetch -y"
    run_command "sudo apt update"
    run_command "sudo apt install -y fastfetch"
    print_success "Fastfetch installed"
else
    print_success "Fastfetch already installed"
fi

# ============================================
# NERD FONTS (Patched fonts with icons)
# ============================================
print_step "Installing Nerd Fonts..."
run_command "sudo apt install -y fontconfig wget"
FONT_DIR="$HOME/.local/share/fonts"
run_command "mkdir -p '$FONT_DIR'"

if [ ! -f "$FONT_DIR/UbuntuMonoNerdFontMono-Regular.ttf" ]; then
    # Download Ubuntu Mono Nerd Font
    run_command "wget -q https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/UbuntuMono/Regular/UbuntuMonoNerdFontMono-Regular.ttf -P '$FONT_DIR'"
    # Rebuild font cache
    run_command "fc-cache -fv"
    print_success "Nerd Fonts installed"
else
    print_success "Nerd Fonts already installed"
fi

# ============================================
# PYTHON DEVELOPMENT TOOLS (Optional)
# ============================================
if command_exists python3; then
    print_step "Installing Python development tools..."
    # Install pip and virtual environment tools
    run_command "sudo apt install -y python3-pip python3-venv python3-virtualenv"
    # Install enhanced Python REPL
    run_command "pip3 install --user bpython"
    print_success "Python tools installed"
fi

# ============================================
# APPLY DOTFILES WITH GNU STOW
# ============================================
print_step "Applying dotfiles with GNU Stow..."

# Create backup directory for existing files
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
run_command "mkdir -p '$BACKUP_DIR'"

# Backup existing .zshrc if present
if [ -f "$HOME/.zshrc" ] && [ "$DRY_RUN" = false ]; then
    print_warning "Backing up existing .zshrc to $BACKUP_DIR"
    mv "$HOME/.zshrc" "$BACKUP_DIR/"
elif [ -f "$HOME/.zshrc" ]; then
    print_warning "Would backup existing .zshrc to $BACKUP_DIR"
fi

# Apply dotfiles using stow (creates symlinks)
run_command "cd '$HOME/.dotfiles' && stow --adopt ."

print_success "Dotfiles applied successfully"

# ============================================
# CHANGE DEFAULT SHELL
# ============================================
if [ "$SHELL" != "$(which zsh)" ]; then
    print_step "Changing default shell to Zsh..."
    run_command "sudo chsh -s '$(which zsh)' '$(whoami)'"
    print_success "Default shell changed to Zsh (restart terminal to apply)"
else
    print_success "Zsh is already the default shell"
fi

# ============================================
# FINAL STEPS
# ============================================
echo ""
if [ "$DRY_RUN" = true ]; then
    echo -e "${BLUE}================================================${NC}"
    echo -e "${BLUE}🔍 DRY RUN COMPLETED${NC}"
    echo -e "${BLUE}================================================${NC}"
    echo ""
    echo -e "${YELLOW}This was a test run. No changes were made.${NC}"
    echo -e "To actually install, run: ${GREEN}./scripts/setup.sh${NC}"
else
    echo -e "${GREEN}================================================${NC}"
    echo -e "${GREEN}✓ Setup completed successfully!${NC}"
    echo -e "${GREEN}================================================${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo -e "  1. Restart your terminal or run: ${BLUE}exec zsh${NC}"
    echo -e "  2. Open Neovim to install plugins: ${BLUE}nvim${NC}"
    echo -e "  3. Claude Code CLI is ready to use: ${BLUE}claude-code${NC}"
    echo ""
    echo -e "${YELLOW}Optional:${NC}"
    echo -e "  - Configure Git: ${BLUE}git config --global user.name 'Your Name'${NC}"
    echo -e "  - Configure Git: ${BLUE}git config --global user.email 'your@email.com'${NC}"
    echo -e "  - Set up SSH key: ${BLUE}ssh-keygen -t ed25519 -C 'your@email.com'${NC}"
fi
echo ""
