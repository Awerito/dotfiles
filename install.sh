#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# ============================================
# PACKAGES
# ============================================
BASE_PACKAGES=(
  zsh
  oh-my-zsh-git
  zsh-autosuggestions
  zsh-syntax-highlighting
  neovim
  kitty
  fastfetch
  stow
  fzf
  ripgrep
  jq
  ttf-meslo-nerd
)

HYPRDE_PACKAGES=(
  # Compositor
  hyprland
  hyprlock
  hyprpolkitagent
  hyprpicker
  hypridle
  ags-hyprpanel-git
  xdg-desktop-portal-hyprland
  xorg-xwayland

  # Wallpaper
  awww

  # Clipboard
  wl-clipboard
  wl-clip-persist
  cliphist

  # Screenshots
  grim
  slurp
  grimblast-git
  tesseract
  tesseract-data-eng
  tesseract-data-spa

  # Apps
  rofi
  rofimoji
  wtype
  pavucontrol
  brightnessctl
  gnome-keyring
  hyprswitch

  # Login
  greetd-tuigreet
)

# ============================================
# INSTALL
# ============================================
echo "Installing packages..."
paru -S --needed "${BASE_PACKAGES[@]}" "${HYPRDE_PACKAGES[@]}"

# ============================================
# ZSH PLUGINS
# ============================================
echo "Linking zsh plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"

for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
  if [ ! -e "$ZSH_CUSTOM/plugins/$plugin" ]; then
    ln -s "/usr/share/zsh/plugins/$plugin" "$ZSH_CUSTOM/plugins/$plugin"
  fi
done

# ============================================
# YAZI PLUGINS
# ============================================
echo "Installing yazi plugins..."
ya pkg add bennyyip/gruvbox-dark
ya pkg add yazi-rs/plugins:full-border
ya pkg add yazi-rs/plugins:jump-to-char
ya pkg add yazi-rs/plugins:smart-filter
ya pkg add yazi-rs/plugins:chmod
ya pkg add yazi-rs/plugins:git

# ============================================
# DEFAULT SHELL
# ============================================
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Changing default shell to zsh..."
  chsh -s "$(which zsh)"
fi

# ============================================
# DONE
# ============================================
echo ""
echo "Done. Manual steps:"
echo ""
echo "  sudo cp -r $DOTFILES_DIR/system/etc/greetd/ /etc/greetd/"
echo "  cd $DOTFILES_DIR && stow base"
echo "  cd $DOTFILES_DIR && stow hyprde"
