# Dotfiles

Personal configurations for a CachyOS (Arch-based) development environment.

## Stow packages

| Package | What it includes |
|---------|-----------------|
| `base` | zsh, nvim, kitty, fastfetch, stylua, imv, scripts |
| `hyprde` | hyprland, hyprpanel, rofi, yazi |
| `system` | greetd config (`/etc`, not stowable — copy manually) |

## Installation

```bash
git clone https://github.com/Awerito/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow base
stow hyprde
```

## Dependencies

### Base
- zsh
- oh-my-zsh
- neovim
- kitty
- fastfetch
- stow
- fzf
- ripgrep
- jq
- ttf-meslo-nerd
- zsh-autosuggestions
- zsh-syntax-highlighting

### HyprDE
- hyprland
- hyprlock
- hypridle
- hyprpicker
- hyprpolkitagent
- hyprpanel
- xdg-desktop-portal-hyprland
- xorg-xwayland
- awww
- wl-clipboard
- wl-clip-persist
- cliphist
- grim
- slurp
- grimblast
- tesseract (with eng/spa data)
- rofi
- pavucontrol
- brightnessctl
- gnome-keyring
- greetd-tuigreet
- hyprswitch

All installed via `./install.sh`.

## License

MIT — see [LICENSE](LICENSE).
