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

hl.window_rule({
	match = {
		class = "^(discord)$",
	},
	workspace = "5 silent",
	float = true,
	size = "1000 500",
	center = true,
})

hl.window_rule({
	match = {
		class = "Thunar",
	},
	float = true,
	size = "700 500",
	center = true,
})
