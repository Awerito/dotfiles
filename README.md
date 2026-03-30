# Dotfiles

Personal configurations for a CachyOS (Arch-based) development environment.

## Contents

This repository includes configurations for:

- **Hyprland DE** (hyprde stow package) - Full desktop environment on Wayland
- **Neovim** with modern configuration (LSP, Treesitter, Telescope, etc.)
- **Kitty** terminal emulator
- **Zsh** + Oh My Zsh with autosuggestions and syntax highlighting
- **Fastfetch** for system information
- Custom shell scripts and functions

## Desktop Environment (hyprde)

Minimal Wayland DE built on Hyprland, designed to replicate COSMIC tiling behavior.

### Stack

| Component | Tool |
|-----------|------|
| Compositor | Hyprland (Dwindle BSP auto-tile) |
| Bar/Panel | HyprPanel (AGS) |
| Wallpaper | swww (awww) |
| Clipboard | cliphist + wl-clip-persist |
| Screenshots | grim + slurp |
| Calendar | gsimplecal |
| Lock screen | swaylock |
| File manager | Thunar + Yazi |
| Polkit | polkit-gnome |

### Key bindings

| Binding | Action |
|---------|--------|
| Super (tap) | App launcher (wofi) |
| Super + Enter | Kitty terminal |
| Super + Q | Close window |
| Super + F | Fullscreen |
| Super + M | Toggle float/tile |
| Super + HJKL | Focus between windows |
| Ctrl + Super + H/L | Switch desktop left/right |
| Shift + Super + HJKL | Move/swap window (cross-desktop at edges) |
| Print | Screenshot (area select) |
| Super + Print | Screenshot (focused window) |

### Stow structure

```
hyprde/
└── .config/
    ├── hypr/
    │   ├── hyprland.conf
    │   ├── hyprkool.toml
    │   └── scripts/
    │       ├── hypr-grid
    │       ├── hypr-movewindow
    │       └── set-wallpaper
    ├── hyprpanel/
    │   ├── config.json
    │   └── modules.json
    └── yazi/
        ├── keymap.toml
        └── init.lua
```

### Theme

- Gruvbox dark color scheme
- Accent: desaturated pink (#d4a0b9)
- Font: MesloLGS Nerd Font Mono 13px
- Bar: HyprPanel with 85% opacity

### Yazi shortcuts

| Key | Action |
|-----|--------|
| W | Set hovered image as wallpaper |

## Other configurations

### Neovim (.config/nvim/)

Modular configuration with LSP, Treesitter, Telescope, autocompletion, and format on save.

### Kitty (.config/kitty/)

Performance-optimized with ligatures and Nerd Font support.

### Zsh (.zshrc)

Oh My Zsh with custom functions: `ex` (extract), `repos` (fuzzy repo browser), `v` (fzf file opener).

## Installation

```bash
git clone https://github.com/Awerito/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow hyprde  # Desktop environment
```

### Hyprland DE dependencies

```bash
sudo pacman -S --needed hyprland waybar thunar gvfs gvfs-mtp tumbler \
  wl-clipboard cliphist grim slurp swaybg swaylock \
  polkit-gnome xdg-desktop-portal-hyprland \
  wl-clip-persist gsimplecal awww dart-sass gtksourceview3
paru -S ags-hyprpanel-git
```

## Stow management

```bash
cd ~/.dotfiles
stow hyprde        # Apply DE configs
stow -D hyprde     # Remove DE symlinks
stow -R hyprde     # Re-apply (unstow + stow)
stow --adopt hyprde # Adopt existing files into stow
```

## License

MIT License - see the [LICENSE](LICENSE) file for more details.
