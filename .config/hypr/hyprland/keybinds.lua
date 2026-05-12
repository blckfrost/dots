local terminal = "kitty"
local file = "Thunar"
local nipc = "qs -c noctalia-shell ipc call"

hl.bind("SUPER + Return", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + F", hl.dsp.exec_cmd("zen-browser"))
hl.bind("SUPER + Q", hl.dsp.window.close())

-- NOCTALIA
hl.bind("SUPER + comma", hl.dsp.exec_cmd(nipc .. " settings toggle"))
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd(nipc .. " controlCenter toggle"))
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd(nipc .. " wallpaper toggle"))
hl.bind("SUPER + N", hl.dsp.exec_cmd(nipc .. " network togglePanel"))
hl.bind("Print", hl.dsp.exec_cmd(nipc .. " plugin:screen-shot-and-record screenshot"))
hl.bind("SUPER + Print", hl.dsp.exec_cmd(nipc .. " plugin:screen-shot-and-record record"))

for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move" })
hl.bind("SUPER + mouse:274", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize" })
