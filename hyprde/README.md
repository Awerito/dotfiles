# HyprDE

Minimal Hyprland DE with BSP auto-tiling, gruvbox dark theme, pink (#d4a0b9) accent.

## Install

```bash
# 1. Install packages
paru -S --needed - < ~/.dotfiles/hyprde/packages.txt

# 2. Stow dotfiles
cd ~/.dotfiles && stow hyprde

# 3. Generate locale (for calendar week starting Monday)
# Uncomment en_GB.UTF-8 in /etc/locale.gen, then:
sudo locale-gen

# 4. Configure greetd (/etc/greetd/config.toml)
```

```toml
[terminal]
vt = 1

[initial_session]
command = "/usr/bin/start-hyprland"
user = "awe"

[default_session]
command = "tuigreet --cmd /usr/bin/start-hyprland --remember"
user = "greeter"
```

```bash
# 5. Enable greetd
sudo systemctl enable greetd

# 6. Reboot
```

## Keybinds

| Key | Action |
|---|---|
| Super+Enter | Terminal (kitty) |
| Super (tap) | App launcher (rofi) |
| Super+Q | Close window |
| Super+F | Fullscreen |
| Super+M | Maximize (toggle) |
| Super+H/J/K/L | Focus window (H/L cross desktops at edges) |
| Super+Shift+H/J/K/L | Move window (crosses desktops at edges) |
| Super+Ctrl+H/L | Switch desktop |
| Super+1-5 | Go to desktop 1-5 |
| Super+Escape | Lock screen |
| Super+Shift+V | Clipboard history |
| Print | Screenshot area (freeze) |
| Super+Print | Screenshot active window |
| Super+Shift+Print | Screenshot full screen |

## Notes

- greetd autologins to Hyprland, hyprlock --immediate locks at startup
- 5 workspaces, navigation wraps at edges via scripts
