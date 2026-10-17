local mainMod = "SUPER"
local terminal = "alacritty"
local fileManager = "dolphin"
local launcher = "rofi -show drun"

hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.monitor({ output = "VGA-1", mode = "1366x768", position = "auto", scale = 1 })

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 4,
        border_size = 1,
        col = {
            active_border = "rgba(bdbdbdff)",
            inactive_border = "rgba(414141ff)",
        },
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 0,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = { enabled = false },
        blur = { enabled = false },
    },
    animations = { enabled = true },
    dwindle = { preserve_split = true },
    misc = { disable_hyprland_logo = true, force_default_wallpaper = 0 },
    input = { follow_mouse = 1, sensitivity = 0 },
})

hl.curve("monoEase", {
    type = "bezier",
    points = { { 0.25, 0.1 }, { 0.25, 1.0 } },
})
hl.animation({ leaf = "global", enabled = true, speed = 5, bezier = "monoEase" })
hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "monoEase" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "monoEase" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "monoEase" })
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "monoEase" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "monoEase" })

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)

-- Preserve the familiar SUPER shortcuts; SUPER+E intentionally starts Dolphin.
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(launcher))
hl.bind(mainMod .. " + V", hl.dsp.window.float())
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SPACE", hl.dsp.window.float())

for _, direction in ipairs({
    { key = "left", dir = "left", x = -24, y = 0 },
    { key = "right", dir = "right", x = 24, y = 0 },
    { key = "up", dir = "up", x = 0, y = -24 },
    { key = "down", dir = "down", x = 0, y = 24 },
}) do
    hl.bind(mainMod .. " + " .. direction.key,
        hl.dsp.focus({ direction = direction.dir }))
    hl.bind(mainMod .. " + SHIFT + " .. direction.key,
        hl.dsp.window.move({ direction = direction.dir }))
    hl.bind(mainMod .. " + CTRL + " .. direction.key,
        hl.dsp.window.resize({ x = direction.x, y = direction.y, relative = true }),
        { repeating = true })
end

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,
        hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S",
    hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + comma", hl.dsp.focus({ monitor = "-1" }))
hl.bind(mainMod .. " + period", hl.dsp.focus({ monitor = "+1" }))
hl.bind(mainMod .. " + SHIFT + comma",
    hl.dsp.window.move({ monitor = "-1" }))
hl.bind(mainMod .. " + SHIFT + period",
    hl.dsp.window.move({ monitor = "+1" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("PRINT", hl.dsp.exec_cmd("~/.local/bin/screenshot-region"))
hl.bind(mainMod .. " + SHIFT + V",
    hl.dsp.exec_cmd("~/.local/bin/cliphist-rofi"))
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd("pavucontrol"))

hl.bind("XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true })
hl.bind("XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86MonBrightnessUp",
    hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",
    hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),
    { locked = true, repeating = true })
