-- hyprland.lua (converted to the hl.* API style)

local terminal = "ghostty"
local browser = "firefox"
local fileManager = "nautilus"
local menu = "wofi --show drun"

local mainMod = "SUPER"
local shiftKey = "SHIFT"

-- MONITOR
hl.monitor({
    output = "DP-2",
    mode = "2560x1440@260",
    position = "auto",
    scale = "1",
})

-- AUTOSTART
hl.on("hyprland.start", function()
    hl.exec_cmd("swaync")
    hl.exec_cmd("hyprpaper")

    hl.exec_cmd('[workspace 1 silent] ' .. terminal)
    hl.exec_cmd('[workspace 2 silent] ' .. browser)
    hl.exec_cmd('[workspace 3 silent] steam')
    hl.exec_cmd('[workspace special:magic silent] discord')

    -- hl.exec_cmd("~/.config/hypr/toggle.sh")
    hl.exec_cmd("~/.config/hypr/start_obs.sh")
end)

-- ENVIRONMENT VARIABLES
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GTK_THEME", "catppuccin-mocha")
hl.env("XCURSOR_THEME", "Adwaita")
hl.env("XFT_FONT", "Ubuntu Mono")
hl.env("GDK_SCALE", "1")

-- LOOK AND FEEL
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 20,
        border_size = 2,

        col = {
            active_border = { colors = { "rgba(f0f0f0f0)", "rgba(f0f0f0f0)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding = 10,
        active_opacity = 1.0,
        inactive_opacity = 1.0,

        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Curves (maps your "bezier = ..." lines)
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Animations (maps your "animation = ..." lines)
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = false, speed = 1.94, bezier = "almostLinear", style = "fade" })

-- LAYOUTS
hl.config({
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    misc = {
    },
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        accel_profile = "flat",
        follow_mouse = 1,
        sensitivity = -0.4,
    },
})

-- KEYBINDS
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))

-- dwindle binds
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- Print / screenshots (your hyprlang uses hyprshot + swappy, keep as raw shell)
hl.bind(shiftKey .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m region -r - | swappy -f -"))
hl.bind(" + PRINT", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))

-- Replay buffer script bind
hl.bind("CTRL + ALT + S",
    hl.dsp.exec_cmd("/home/ollie/.nvm/versions/node/v22.19.0/bin/node /home/ollie/replay-buffer/save_replaybuffer.js"))

-- Focus move
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Fullscreen
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

-- Workspaces focus
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- Move active window to workspace
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Special workspace (magic scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Move/resize with mouse drag (converted from bindm)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- WINDOW RULES
hl.window_rule({
    name = "defaults-no-focus-empty",
    match = { class = "^$", title = "^$", xwayland = true },
    no_focus = true,
    float = true,
    fullscreen = false,
    pin = false,
})

hl.window_rule({
    name = "float-simplex",
    match = { title = "^(Simplex)$" },
    float = true,
})

hl.window_rule({
    name = "steam-to-workspace3",
    match = { class = "^(steam)$" },
    workspace = "3",
})

hl.window_rule({
    name = "minecraft-launcher-to-workspace3",
    match = { title = "^(minecraft-launcher)$" },
    workspace = "3",
})

hl.window_rule({
    name = "java-to-workspace3",
    match = { class = "^(java)$" },
    workspace = "3",
})

hl.window_rule({
    name = "discord-to-special-magic",
    match = { class = "^(discord)$" },
    workspace = "special:magic",
})
