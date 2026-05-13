hl.config({
	general = {
		gaps_in = 4,
		gaps_out = 4,
		border_size = 0,
		layout = "master",
		allow_tearing = false,
		resize_on_border = true,

		snap = {
			enabled = true,
			window_gap = 10,
			monitor_gap = 10,
			border_overlap = true,
		},
	},

	decoration = {
		rounding = 8,
		rounding_power = 2,

		blur = {
			enabled = true,
			size = 4,
			passes = 2,
			new_optimizations = true,
			popups = true,
			xray = true,
			brightness = 1.1,
			contrast = 1.1,
			vibrancy = 0.0696,
			ignore_opacity = true,
			noise = 0.1101,
		},

		shadow = {
			enabled = true,
			render_power = 2,
			range = 12,
			color = "rgb(000000)",
			color_inactive = "0xee",
		},

		dim_special = 0.35,
		fullscreen_opacity = 1.0,
	},

	master = {
		new_status = "slave",
		mfact = 0.5,
		new_on_top = false,
	},

	misc = {
		force_default_wallpaper = 0,
		animate_mouse_windowdragging = true,
		animate_manual_resizes = true,
		disable_splash_rendering = true,
		enable_swallow = true,
		disable_hyprland_logo = true,
	},

	dwindle = {
		preserve_split = true,
		special_scale_factor = 0.8,
	},
	ecosystem = {
		enforce_permissions = true,
	},
})
