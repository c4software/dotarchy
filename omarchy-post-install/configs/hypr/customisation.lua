-- Migré depuis customisation.conf

-- Monitors
hl.monitor({ output = "eDP-1", mode = "2880x1920@60", position = "auto", scale = 2 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
-- Stock monitors sets GDK_SCALE=2 for retina displays; override it back to 1
hl.env("GDK_SCALE", "1")

-- Input
hl.config({
	input = {
		kb_layout = "bepoDev,us,fr",
		kb_variant = ",,ergol", -- sinon hérité de vconsole.conf (bepo), inconnu de bepoDev
		kb_options = "lv3:caps_switch,grp:alts_toggle",
	},
})

-- Enable touchpad gestures for changing workspaces (commented out in stock)
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "vertical", action = "fullscreen", mode = "maximize" })

-- Note: stock input applies scroll_touchpad 1.5 to (Alacritty|kitty|foot);
-- my version dropped foot from the regex, but that removal can't be expressed
-- as an additive rule — the stock rule is kept as-is.

-- Bindings — added
dofile(os.getenv("HOME") .. "/.config/omarchy/plugins/vbrosseau.alttab/omarchy-plugin/alttab-bindings.lua")

-- Was: unbind SUPER, code:61 / SUPER ALT, code:61 — the Lua defaults now bind
-- monitor scaling by keysym (SLASH) instead of keycode.
hl.unbind("SUPER + SLASH")
hl.unbind("SUPER + ALT + SLASH")

o.bind("ALT + UP", "Full width", "omarchy-expand-full-width")
o.bind("ALT + DOWN", "Full width", "omarchy-expand-full-width")
o.window({ fullscreen = 1 }, { border_color = "rgb(FF0000) rgb(880808)" })

-- Bureau précédent/suivant parmi les 10 de l'écran actif (vides compris),
-- avec bouclage 10 → 1. Passe par o.workspaces pour respecter les blocs par écran.
local function relative_slot(delta)
	local ws = hl.get_active_workspace()
	if not ws or ws.special or ws.id <= 0 then
		return nil
	end
	local slots = o.workspaces.slots
	return ((ws.id - 1) % slots + delta) % slots + 1
end

-- Actions pré-construites une fois (o.workspaces enregistre chaque action créée).
local focus_slot, move_slot = {}, {}
for slot = 1, o.workspaces.slots do
	focus_slot[slot] = o.workspaces.focus(slot)
	move_slot[slot] = o.workspaces.move_window(slot)
end

local function focus_relative(delta)
	return function()
		local slot = relative_slot(delta)
		if slot then
			focus_slot[slot]()
		end
	end
end

local function move_relative(delta)
	return function()
		local slot = relative_slot(delta)
		if slot then
			move_slot[slot]()
		end
	end
end

o.bind("ALT + LEFT", "Previous workspace", focus_relative(-1))
o.bind("ALT + RIGHT", "Next workspace", focus_relative(1))
-- Remplace les stock « Move window to group on left/right ».
hl.unbind("SUPER + ALT + LEFT")
hl.unbind("SUPER + ALT + RIGHT")
o.bind("SUPER + ALT + LEFT", "Move window to previous workspace", move_relative(-1))
o.bind("SUPER + ALT + RIGHT", "Move window to next workspace", move_relative(1))

o.bind("ALT + SHIFT + RIGHT", nil, hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
o.bind("ALT + SHIFT + LEFT", nil, hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
o.bind("ALT + SHIFT + UP", nil, hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
o.bind("ALT + SHIFT + DOWN", nil, hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })

hl.unbind("ALT + SHIFT + code:13")
o.bind("ALT + SHIFT + code:13", nil, "omarchy-menu summon capture")

-- Console Quake : la stock (qconsole.lua) l'amorce avec omarchy-agent via un
-- hook workspace.created qu'on ne peut pas désenregistrer. On intercepte donc
-- hl.exec_cmd pour lancer tmux à la place, uniquement pour ce cas précis.
local stock_exec_cmd = hl.exec_cmd
hl.exec_cmd = function(cmd, opts, ...)
	if cmd == "omarchy-agent" and opts and type(opts.workspace) == "string" and opts.workspace:find("^special:qconsole") then
		cmd = "omarchy-launch-terminal-tmux"
	end
	return stock_exec_cmd(cmd, opts, ...)
end

-- Console Quake sur Super + $ (Super + ~ est peu accessible en bépo).
o.bind("SUPER + dollar", "Toggle Quake console", hl.dsp.workspace.toggle_special("qconsole"))
o.bind(
	"SUPER + SHIFT + dollar",
	"Move window to Quake console",
	hl.dsp.window.move({ workspace = "special:qconsole", follow = false })
)

-- Redimensionner en tirant les bordures, en tiling comme en floating (comme upstream).
hl.config({ general = { resize_on_border = true, extend_border_grab_area = 8 } })
