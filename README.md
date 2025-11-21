# Dotfiles

Personal configurations for a modern Linux development environment (Ubuntu/Debian).

## Contents

This repository includes configurations for:

- **Zsh** + Oh My Zsh with autosuggestions and syntax highlighting plugins
- **Neovim** with modern configuration (LSP, Treesitter, Telescope, etc.)
- **Kitty** terminal emulator
- **Fastfetch** for system information
- **Git** aliases and useful configurations
- Custom shell scripts and functions

## Overview

```
.dotfiles/
├── .config/
│   ├── nvim/          # Neovim configuration
│   ├── kitty/         # Kitty terminal configuration
│   ├── fastfetch/     # Fastfetch configuration
│   └── stylua/        # Lua formatter
├── .zshrc             # Main Zsh configuration
└── scripts/
    └── setup.sh       # Automated installation script
```

## Prerequisites

- Ubuntu/Debian-based operating system (Ubuntu, Pop!_OS, Linux Mint, etc.)
- `sudo` access
- Internet connection
- Git installed (automatically installed if not present)

## Quick Installation

### Option 1: Clone and run

```bash
# Clone the repository to ~/.dotfiles
git clone https://github.com/Awerito/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run setup
./scripts/setup.sh
```

### Option 2: Test before installing (Dry Run)

To see what the script would do without making any real changes:

```bash
./scripts/setup.sh --dry-run
# or also:
./scripts/setup.sh --test
```

### Option 3: One-liner from GitHub/GitLab

First update the repo URL in `scripts/install.sh`, then:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Awerito/dotfiles/master/scripts/install.sh)"
```

## What the Script Installs

### Essential Tools
- **Git, curl, wget**: Basic tools
- **GNU Stow**: To manage dotfiles symlinks
- **ripgrep, fzf, fd**: Fast file and content search
- **xclip**: System clipboard integration
- **tree, htop**: Visualization utilities

### Development Environment
- **Zsh** + **Oh My Zsh**: Modern shell with framework
  - Plugin: zsh-autosuggestions
  - Plugin: zsh-syntax-highlighting
- **Neovim** (latest version): Advanced text editor
- **NVM** + **Node.js LTS**: Node version manager
- **Claude Code CLI**: AI-powered code assistant

### Terminal and UI
- **Kitty**: Fast and modern terminal emulator
- **Fastfetch**: Stylish system information
- **Nerd Fonts**: Icon fonts for terminal (Ubuntu Mono)

### Python (optional)
- pip, venv, virtualenv
- bpython: Enhanced interactive REPL

## Main Features

### Zsh (.zshrc:1)

**Custom functions:**
- `ex <file>`: Extract any type of compressed file (.zshrc:38)
- `repos`: Fuzzy Git repository browser with onefetch (.zshrc:62)
- `ytd`: Download YouTube videos from clipboard (.zshrc:66)
- `gi <languages>`: Generate .gitignore files from toptal.com (.zshrc:70)

**Useful aliases:**
```bash
# System
update        # Update system packages
clean         # Clean unused packages
l, ll, la     # Enhanced file listings

# Git (.zshrc:87)
gs            # git status
gd            # git diff with nvimdiff
gl            # git log with pretty format
glb           # git log with commit body

# Development (.zshrc:96)
e             # open nvim
vimrc         # edit nvim configuration
v             # find and open files with fzf
py            # python3.12
```

### Neovim (.config/nvim/init.lua:1)

Modern configuration with:
- Integrated LSP (Language Server Protocol)
- Treesitter for advanced syntax highlighting
- Telescope for fuzzy navigation
- Intelligent autocompletion
- Git integration
- Multi-language support
- Enhanced vi mode with spacebar leader

### Kitty Terminal (.config/kitty/kitty.conf)

- Performance-optimized configuration
- Typographic ligatures support
- Custom themes
- Intuitive keyboard shortcuts

### Fastfetch (.config/fastfetch/config.jsonc)

- Fast system information display
- Custom configuration with waifu image

## Post-Installation Configuration

### 1. Restart terminal

```bash
exec zsh
```

### 2. Configure Git

```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### 3. Generate SSH Key (optional)

```bash
ssh-keygen -t ed25519 -C "your@email.com"
cat ~/.ssh/id_ed25519.pub
# Copy the output and add it to GitHub/GitLab
```

### 4. Configure Claude Code (optional)

```bash
claude-code auth login
```

### 5. Open Neovim

The first time you open Neovim, plugins will be installed automatically:

```bash
nvim
```

## Customization

### Modify configurations

All configurations are in separate files for easy editing:

```bash
# Edit Zsh
nvim ~/.zshrc

# Edit Neovim
nvim ~/.config/nvim/init.lua

# Edit Kitty
nvim ~/.config/kitty/kitty.conf

# Edit Fastfetch
nvim ~/.config/fastfetch/config.jsonc
```

### Add new configurations

1. Add your files to the `~/.dotfiles` repository
2. Use GNU Stow to create the symlinks:
   ```bash
   cd ~/.dotfiles
   stow --adopt .
   ```

## Uninstallation

To remove symlinks created by Stow:

```bash
cd ~/.dotfiles
stow -D .
```

To uninstall completely:

```bash
# Remove symlinks
cd ~/.dotfiles
stow -D .

# Restore default shell
chsh -s /bin/bash

# Remove directories (optional, backup first)
rm -rf ~/.dotfiles
rm -rf ~/.oh-my-zsh
rm -rf ~/.nvm
```

## Stow Management Structure

This repository uses GNU Stow to manage symlinks. Stow creates symbolic links from `~/.dotfiles/` to your `$HOME`, enabling:

- Git versioning
- Easy synchronization between machines
- Simple rollback of changes
- Automatic configuration backups

## Troubleshooting

### Error: "command not found" after installation

Restart your terminal or run:
```bash
exec zsh
```

### Neovim doesn't show icons correctly

Make sure your terminal is using a Nerd Font:
- In Kitty: check `~/.config/kitty/kitty.conf`
- Ubuntu Mono Nerd Font is installed automatically

### Zsh plugins don't work

Plugins auto-install on first startup. If there are issues, run:
```bash
source ~/.zshrc
```

### Problems with NVM

Load NVM manually:
```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

### Script fails with permission errors

Make sure you have sudo permissions:
```bash
sudo -v
./scripts/setup.sh
```

## Dry Run Mode

Before running the full script, you can test to see what changes it would make:

```bash
./scripts/setup.sh --dry-run
```

This will show all the actions it would execute without making any real changes to your system.

## License

MIT License - see the [LICENSE](LICENSE) file for more details.

## Acknowledgments

- [Oh My Zsh](https://ohmyz.sh/)
- [Neovim](https://neovim.io/)
- [Kitty](https://sw.kovidgoyal.net/kitty/)
- [GNU Stow](https://www.gnu.org/software/stow/)
- GitHub dotfiles community

---

**Note**: This is a personal development environment. Feel free to fork and adapt it to your needs.
