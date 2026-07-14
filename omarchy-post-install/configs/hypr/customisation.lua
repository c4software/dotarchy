-- Version Lua de customisation.conf, en préparation de la migration vers le
-- nouveau format de config Hyprland (>= 0.55, hyprlang déprécié).
-- API : /usr/share/hypr/hyprland.lua (exemple) et /usr/share/hypr/stubs/hl.meta.lua
--
-- ATTENTION : ne pas déployer tel quel. Dès que ~/.config/hypr/hyprland.lua
-- existe, Hyprland bascule sur le gestionnaire de config Lua et ne lit PLUS
-- AUCUN fichier .conf (défauts Omarchy, thème, toggles inclus). Ce fichier ne
-- couvre que les customisations ; la migration complète devra aussi porter le
-- reste de la config Omarchy.

-- Monitors
hl.monitor({ output = "eDP-1", mode = "2880x1920@60", position = "auto", scale = 1.67 })
hl.monitor({ output = "",      mode = "preferred",    position = "auto", scale = 1 })
-- Le monitors.conf stock met GDK_SCALE=2 pour les écrans retina ; on repasse à 1
hl.env("GDK_SCALE", "1")

-- Input
hl.config({
    input = {
        kb_layout  = "bepoDev",
        kb_options = "lv3:caps_switch", -- ,grp:alts_toggle
    },
})

-- Gestes touchpad pour changer de workspace (commentés dans le stock)
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "vertical",   action = "fullscreen", mode = "1" })

-- Bindings — ajoutés
-- (les unbind hyprlang deviennent inutiles : en Lua on possède toutes les
-- définitions, il suffit de ne pas déclarer les binds stock indésirables)
hl.bind("ALT + TAB",   hl.dsp.exec_cmd("alttab"), { repeating = true })
hl.bind("SUPER + TAB", hl.dsp.exec_cmd("alttab"), { repeating = true })
hl.layer_rule({
    name    = "no-anim-alttab",
    match   = { namespace = "hypr-alttab" },
    no_anim = true,
})

hl.bind("ALT + up",   hl.dsp.exec_cmd("omarchy-expand-full-width"), { description = "Full width" })
hl.bind("ALT + down", hl.dsp.exec_cmd("omarchy-expand-full-width"), { description = "Full width" })
hl.window_rule({
    name         = "fullscreen-border",
    match        = { fullscreen = 1 },
    border_color = "rgb(FF0000) rgb(880808)",
})

hl.bind("ALT + SHIFT + right", hl.dsp.window.resize({ x = 50,  y = 0 }),   { repeating = true })
hl.bind("ALT + SHIFT + left",  hl.dsp.window.resize({ x = -50, y = 0 }),   { repeating = true })
hl.bind("ALT + SHIFT + up",    hl.dsp.window.resize({ x = 0,   y = -50 }), { repeating = true })
hl.bind("ALT + SHIFT + down",  hl.dsp.window.resize({ x = 0,   y = 50 }),  { repeating = true })

hl.bind("ALT + SHIFT + code:13", hl.dsp.exec_cmd("omarchy-menu capture"))
