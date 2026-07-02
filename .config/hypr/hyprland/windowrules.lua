hl.window_rule({ match = { class = "^()$", title = "^()$" }, no_blur = true })

hl.window_rule({ match = { title = "^(Open File)(.*)$" }, center = true })
hl.window_rule({ match = { title = "^(Open File)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Select a File)(.*)$" }, center = true })
hl.window_rule({ match = { title = "^(Select a File)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Open Folder)(.*)$" }, center = true })
hl.window_rule({ match = { title = "^(Open Folder)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Save As)(.*)$" }, center = true })
hl.window_rule({ match = { title = "^(Save As)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Library)(.*)$" }, center = true })
hl.window_rule({ match = { title = "^(Library)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(File Upload)(.*)$" }, center = true })
hl.window_rule({ match = { title = "^(File Upload)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(.*)(wants to save)$" }, center = true })
hl.window_rule({ match = { title = "^(.*)(wants to save)$" }, float = true })
hl.window_rule({ match = { title = "^(.*)(wants to open)$" }, center = true })
hl.window_rule({ match = { title = "^(.*)(wants to open)$" }, float = true })
hl.window_rule({
	match = {
		class = "^(mpv)$",
	},
	float = true,
	size = "1000 500",
	center = true,
})

local suppressMaximizeRule = hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
suppressMaximizeRule:set_enabled(true)

hl.window_rule({
	match = {
		class = "^(discord)$",
	},
	workspace = "5 silent",
	float = true,
	center = true,
})

hl.window_rule({
	match = {
		class = "thunar",
	},
	float = true,
	size = "700 600",
	center = true,
})

hl.window_rule({
	name = "portal-gtk",
	match = { class = "xdg-desktop-portal.gtk" },
	float = true,
	size = "700 400",
	center = true,
})

hl.window_rule({
	match = {
		class = "^(org.pwmt.zathura)$",
	},
	float = true,
	size = "700 730",
	center = true,
})

hl.window_rule({
	name = "kitty",
	match = { class = "kitty" },
	float = true,
	size = "850 650",
	center = true,
})

-- Terminal Cascade Feature
hl.on("window.open", function(win)
	local win_addr = win.address
	hl.timer(function()
		local active_ws = hl.get_active_workspace()
		if not active_ws then
			return
		end

		local is_kitty = false
		for _, w in pairs(hl.get_windows()) do
			if w.address == win_addr then
				if w.class == "kitty" or w.class == "kitty" then
					is_kitty = true
				end
				break
			end
		end

		if not is_kitty then
			return
		end

		for _, w in pairs(hl.get_windows()) do
			if
				(w.class == "kitty" or w.class == "kitty")
				and w.workspace.id == active_ws.id
				and w.address ~= win_addr
				and w.size.x <= 860
			then
				-- Check if the background window is part of the center stack
				-- The new window (win) spawns exactly at the center. We compare horizontal centers.
				local win_center_x = win.at.x + (win.size.x / 2)
				local w_center_x = w.at.x + (w.size.x / 2)

				if math.abs(win_center_x - w_center_x) <= 2 then
					hl.dispatch(hl.dsp.window.float({ action = "on", window = w }))
					hl.dispatch(hl.dsp.window.resize({ x = -20, y = -20, relative = true, window = w }))
					hl.dispatch(hl.dsp.window.move({ x = 0, y = -20, relative = true, window = w }))
				end
			end
		end
	end, { timeout = 100, type = "oneshot" })
end)
