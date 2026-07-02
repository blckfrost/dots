local p = require("hyprland.programs")
local file_manager = "Thunar"
local nipc = "qs -c noctalia-shell ipc call"


-- APPS
hl.bind("SUPER + Return", hl.dsp.exec_cmd(p.terminal))
hl.bind("SUPER + T", hl.dsp.exec_cmd(p.fileManager))
hl.bind("SUPER + F", hl.dsp.exec_cmd("zen-browser"))
hl.bind("SUPER + O", hl.dsp.exec_cmd("obsidian"))

-- NOCTALIA
hl.bind("SUPER + comma", hl.dsp.exec_cmd(nipc .. " settings toggle"))
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd(nipc .. " controlCenter toggle"))
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd(nipc .. " wallpaper toggle"))
hl.bind("SUPER + N", hl.dsp.exec_cmd(nipc .. " network togglePanel"))
hl.bind("Print", hl.dsp.exec_cmd(nipc .. " plugin:screen-shot-and-record screenshot"))
hl.bind("SUPER + Print", hl.dsp.exec_cmd(nipc .. " plugin:screen-shot-and-record record"))
hl.bind("SUPER + C", hl.dsp.exec_cmd(nipc .. " plugin:clipboard toggle"))
hl.bind("SUPER + A", hl.dsp.exec_cmd(nipc .. " launcher toggle"))
hl.bind("SUPER + SHIFT + BACKSPACE", hl.dsp.exec_cmd(nipc .. " sessionMenu toggle"))
hl.bind("CTRL + ESCAPE", hl.dsp.exec_cmd(nipc .. " bar toggle"))

hl.bind("SUPER + F5", hl.dsp.exec_cmd(nipc .. " brightness decrease"))
hl.bind("SUPER + F6", hl.dsp.exec_cmd(nipc .. " brightness increase"))
hl.bind("SUPER + F2", hl.dsp.exec_cmd(nipc .. " volume decrease"))
hl.bind("SUPER + F3", hl.dsp.exec_cmd(nipc .. " volume increase"))

-------------------------------
---- WINDOWS AND WORKSPACE ----
-------------------------------

hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + M", hl.dsp.window.center())
hl.bind("SUPER + ALT + RETURN", hl.dsp.window.fullscreen())

-- move window in direction
for i = 1, 4 do
    local arrowkey = { "Left", "Right", "Up", "Down" }
    local focusdir = { "l", "r", "u", "d" }
    hl.bind("SUPER + SHIFT + " .. arrowkey[i], hl.dsp.window.move({ direction = focusdir[i] }))
end

-- move focus in direction
for i = 1, 4 do
    local arrowkey = { "Left", "Right", "Up", "Down" }
    local focusdir = { "l", "r", "u", "d" }
    hl.bind("SUPER + " .. arrowkey[i], hl.dsp.focus({ direction = focusdir[i] }))
end

-- move to workspace
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move" })
hl.bind("SUPER + mouse:274", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize" })

hl.bind("SUPER + Z", hl.dsp.workspace.toggle_special("special"))
hl.bind("SUPER + SHIFT + Z", hl.dsp.window.move({ workspace = "special:special", follow = false }))
