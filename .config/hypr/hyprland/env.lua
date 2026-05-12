hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

hl.env("HYPRSHOT_DIR", "$HOME/Pictures/Screenshots/")

hl.env("CLUTTER_BACKEND", "wayland")
-- hl.env("GDK_BACKEND", "wayland", "x11", "*")

-- Enabling firefox wayland
hl.env("BROWSER", "zen-browser")
hl.env("MOZ_ENABLE_WAYLAND", "1")

hl.env("EDITOR", "nvim")

hl.env("QT_QPA_PLATFORMTHEME", "gtk2")
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
hl.env("QT_STYLE_OVERRIDE", "gtk2")
