-- Monitor (auto-detect resolution and refresh rate)
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- Cursor
hl.env("XCURSOR_THEME", "Adwaita")
hl.env("XCURSOR_SIZE", "24")
hl.env("LC_TIME", "en_GB.UTF-8")

-- Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("hyprlock --grace 0")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("wayle panel start")
    hl.exec_cmd("swww-daemon")
    hl.exec_cmd("wl-clip-persist --clipboard both")
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets,pkcs11")
    hl.exec_cmd("~/.config/hypr/scripts/hypr-brave-unfullscreen-fix")
    hl.exec_cmd("hyprswitch init &")
    hl.exec_cmd("~/.config/hypr/scripts/pip-window-escape")
    hl.exec_cmd("udiskie &")
end)

hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "altgr-intl",
        kb_options = "caps:escape",
        repeat_delay = 250,
        repeat_rate = 45,
        follow_mouse = 2,
        sensitivity = 0,
        accel_profile = "flat",
        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
            disable_while_typing = true,
        },
    },

    general = {
        layout = "dwindle",
        gaps_in = 3,
        gaps_out = 4,
        border_size = 2,
        col = {
            active_border = "rgba(d4a0b9ee)",
            inactive_border = "rgba(313244aa)",
        },
    },

    -- Dwindle (auto-tile BSP)
    dwindle = {
        -- pseudotile = true,
        preserve_split = true,
        force_split = 2,
    },

    decoration = {
        rounding = 4,
        blur = {
            enabled = true,
            size = 5,
            passes = 2,
        },
        shadow = {
            enabled = true,
            range = 10,
            render_power = 3,
            color = "rgba(1a1a2eee)",
        },
    },

    animations = { enabled = true },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        focus_on_activate = true,
    },

    ecosystem = { no_update_news = true },

    -- Workaround: commit-timing-v1 (wayland-protocols 1.48) causes Brave to stop
    -- repainting when unfocused. Disable until upstream fix.
    render = { commit_timing_enabled = false },
})

hl.device({
    name = "elan0676:00-04f3:3195-touchpad",
    sensitivity = 0.4,
    accel_profile = "flat",
})

-- Animations
hl.curve("ease", { type = "bezier", points = { { 0.25, 0.1 }, { 0.25, 1 } } })
hl.animation({ leaf = "windows", enabled = true, speed = 4, bezier = "ease" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "ease", style = "popin 80%" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "ease" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "ease" })

-- plugin hyprexpo (disabled):
--   dynamic_grid = 1, gap_size = 8, bg_col = rgb(1d2021), workspace_method = center current,
--   enable_gesture = false, enable_keyboard_nav = 1, active_highlight_col = 0xFFd4a0b9,
--   active_highlight_border = 2

-- Window rules - Steam
hl.window_rule({ match = { class = "steam" }, float = false })
hl.window_rule({ match = { class = "steam_app_" }, fullscreen = true, immediate = true })
hl.window_rule({ match = { class = "steam", title = "^$" }, float = true, stay_focused = true, min_size = { 1, 1 } })

-- Window rules - General
hl.window_rule({ match = { class = "pavucontrol" }, float = true })
hl.window_rule({ match = { class = "blueman-manager" }, float = true })
hl.window_rule({ match = { title = "Open File" }, float = true })
hl.window_rule({ match = { title = "Save File" }, float = true })
hl.window_rule({ match = { title = "Picture in picture" }, float = true, pin = true })
hl.window_rule({ match = { class = "gsimplecal" }, float = true, pin = true, move = { 1080, 35 } })

-- Chat apps -> workspace 1
hl.window_rule({ match = { class = "slack" }, workspace = "1 silent" })
hl.window_rule({ match = { class = "signal" }, workspace = "1 silent" })
hl.window_rule({ match = { class = "com.rtosta.zapzap" }, workspace = "1 silent" })
hl.window_rule({ match = { class = "brave-akpamiohjfcnimfljfndmaldlcfphjmp-Default" }, workspace = "1 silent" })

-- Pip terminal / Spotify
hl.window_rule({ match = { class = "pipterm" }, workspace = "special:pip", float = true })
hl.window_rule({ match = { class = "spotifast" }, workspace = "special:pipspoti", float = true })

local mainMod = "SUPER"
local scripts = "~/.config/hypr/scripts/"

local function bind(keys, description, dispatcher, opts)
    opts = opts or {}
    opts.description = description
    return hl.bind(keys, dispatcher, opts)
end

-- Apps
bind(mainMod .. " + C", "Open chat apps in 2x2", hl.dsp.exec_cmd(scripts .. "hypr-chats"))
bind(mainMod .. " + Return", "Open terminal", hl.dsp.exec_cmd("kitty"))
bind("Super_L", "Open app launcher", hl.dsp.exec_cmd("rofi -show drun"), { release = true })
bind(mainMod .. " + Q", "Close active window", hl.dsp.window.close())
bind(mainMod .. " + S", "Toggle pip Spotify", hl.dsp.exec_cmd(scripts .. "pipspotify"))
bind(mainMod .. " + B", "Open Brave", hl.dsp.exec_cmd("brave"))
bind(mainMod .. " + F", "Toggle fullscreen", hl.dsp.window.fullscreen({ action = "toggle", mode = "fullscreen" }))
bind(mainMod .. " + M", "Toggle maximize", hl.dsp.window.fullscreen({ action = "toggle", mode = "maximized" }))
bind(mainMod .. " + T", "Arrange 3 windows in columns", hl.dsp.exec_cmd(scripts .. "hypr-3columns"))
bind(mainMod .. " + BackSpace", "Toggle pip terminal", hl.dsp.exec_cmd(scripts .. "pipterm"))
bind(mainMod .. " + E", "Emoji picker", hl.dsp.exec_cmd("rofimoji --selector rofi --action type"))
bind(
    mainMod .. " + G",
    "Copy lsfg-vk launch option",
    hl.dsp.exec_cmd(
        [[sh -c 'printf "LSFG_LEGACY=1 LSFG_MULTIPLIER=2 %%command%%" | wl-copy && notify-send "lsfg-vk" "LSFG_LEGACY=1 LSFG_MULTIPLIER=2 %%command%%\n(copiado al portapapeles)"']]
    )
)

-- Screenshots
bind("Print", "Screenshot area", hl.dsp.exec_cmd(scripts .. "hypr-screenshot area"))
bind("SHIFT + Print", "Screenshot active window", hl.dsp.exec_cmd(scripts .. "hypr-screenshot window"))
bind("CTRL + Print", "Screenshot full screen", hl.dsp.exec_cmd(scripts .. "hypr-screenshot full"))
bind(mainMod .. " + Print", "OCR area to clipboard", hl.dsp.exec_cmd(scripts .. "hypr-screenshot ocr"))
bind(mainMod .. " + SHIFT + V", "Clipboard history", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))
bind(mainMod .. " + Escape", "Lock screen", hl.dsp.exec_cmd("loginctl lock-session"))
bind(mainMod .. " + SHIFT + Escape", "Power menu", hl.dsp.exec_cmd(scripts .. "hypr-wlogout"))
bind(mainMod .. " + SHIFT + P", "Restart status bar", hl.dsp.exec_cmd("wayle panel restart"))

-- Brightness (notebook)
bind("XF86MonBrightnessUp", "Brightness up", hl.dsp.exec_cmd("brightnessctl set 5%+"), { repeating = true })
bind("XF86MonBrightnessDown", "Brightness down", hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true })

-- Volume keys
bind("XF86AudioRaiseVolume", "Volume up", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
bind("XF86AudioLowerVolume", "Volume down", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
bind("XF86AudioMute", "Toggle mute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
bind(mainMod .. " + Left", "Spotify previous", hl.dsp.exec_cmd("playerctl -p spotifast previous"))
bind(mainMod .. " + Down", "Spotify play/pause", hl.dsp.exec_cmd("playerctl -p spotifast play-pause"))
bind(mainMod .. " + Right", "Spotify next", hl.dsp.exec_cmd("playerctl -p spotifast next"))

-- Focus between windows (same workspace)
bind(mainMod .. " + h", "Focus left", hl.dsp.exec_cmd(scripts .. "hypr-smartfocus l"))
bind(mainMod .. " + j", "Focus down", hl.dsp.exec_cmd(scripts .. "hypr-smartfocus d"))
bind(mainMod .. " + k", "Focus up", hl.dsp.exec_cmd(scripts .. "hypr-smartfocus u"))
bind(mainMod .. " + l", "Focus right", hl.dsp.exec_cmd(scripts .. "hypr-smartfocus r"))

-- Switch desktop (horizontal)
bind(mainMod .. " + CTRL + h", "Previous workspace", hl.dsp.exec_cmd(scripts .. "hypr-switchws -1"))
bind(mainMod .. " + CTRL + l", "Next workspace", hl.dsp.exec_cmd(scripts .. "hypr-switchws +1"))
for i = 1, 5 do
    bind(mainMod .. " + " .. i, "Go to workspace " .. i, hl.dsp.focus({ workspace = i }))
end
bind(mainMod .. " + mouse_down", "Previous workspace (scroll)", hl.dsp.exec_cmd(scripts .. "hypr-switchws -1"))
bind(mainMod .. " + mouse_up", "Next workspace (scroll)", hl.dsp.exec_cmd(scripts .. "hypr-switchws +1"))
bind(mainMod .. " + CTRL + Tab", "Next workspace", hl.dsp.exec_cmd(scripts .. "hypr-switchws +1"))
bind(mainMod .. " + CTRL + SHIFT + Tab", "Previous workspace", hl.dsp.exec_cmd(scripts .. "hypr-switchws -1"))
bind(mainMod .. " + SHIFT + mouse_up", "Move window to next workspace (scroll)", hl.dsp.exec_cmd(scripts .. "hypr-movewindow r"))
bind(mainMod .. " + SHIFT + mouse_down", "Move window to previous workspace (scroll)", hl.dsp.exec_cmd(scripts .. "hypr-movewindow l"))

-- Move window: swap within workspace, or to adjacent desktop at edge
bind(mainMod .. " + SHIFT + h", "Move window left", hl.dsp.exec_cmd(scripts .. "hypr-movewindow l"))
bind(mainMod .. " + SHIFT + j", "Move window down", hl.dsp.exec_cmd(scripts .. "hypr-movewindow d"))
bind(mainMod .. " + SHIFT + k", "Move window up", hl.dsp.exec_cmd(scripts .. "hypr-movewindow u"))
bind(mainMod .. " + SHIFT + l", "Move window right", hl.dsp.exec_cmd(scripts .. "hypr-movewindow r"))

-- Window switcher
bind("ALT + Tab", "Window switcher (cycle)", hl.dsp.exec_cmd("hyprswitch gui --mod-key alt --key tab --close mod-key-release --sort-recent"))
bind(
    "ALT + SHIFT + Tab",
    "Window switcher (cycle reverse)",
    hl.dsp.exec_cmd("hyprswitch gui --mod-key alt --key tab --reverse-key=mod=shift --close mod-key-release --sort-recent")
)
bind(mainMod .. " + Tab", "Window finder (search by name)", hl.dsp.exec_cmd("rofi -show window"))
bind(mainMod .. " + slash", "Show all keybinds", hl.dsp.exec_cmd(scripts .. "hypr-keybinds"))
-- bind(mainMod .. " + grave", "Workspace overview", hyprexpo:expo toggle)

-- Monitor navigation
bind(mainMod .. " + ALT + h", "Focus monitor left", hl.dsp.focus({ monitor = "l" }))
bind(mainMod .. " + ALT + j", "Focus monitor down", hl.dsp.focus({ monitor = "d" }))
bind(mainMod .. " + ALT + k", "Focus monitor up", hl.dsp.focus({ monitor = "u" }))
bind(mainMod .. " + ALT + l", "Focus monitor right", hl.dsp.focus({ monitor = "r" }))
bind(mainMod .. " + ALT + SHIFT + h", "Move window to left monitor", hl.dsp.exec_cmd(scripts .. "hypr-movetomonitor l"))
bind(mainMod .. " + ALT + SHIFT + j", "Move window to down monitor", hl.dsp.exec_cmd(scripts .. "hypr-movetomonitor d"))
bind(mainMod .. " + ALT + SHIFT + k", "Move window to up monitor", hl.dsp.exec_cmd(scripts .. "hypr-movetomonitor u"))
bind(mainMod .. " + ALT + SHIFT + l", "Move window to right monitor", hl.dsp.exec_cmd(scripts .. "hypr-movetomonitor r"))

-- Move / resize with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Local overrides not tracked in the repo
local extras = os.getenv("HOME") .. "/.scripts.local/hypr-extras.lua"
if io.open(extras) then
    dofile(extras)
end
