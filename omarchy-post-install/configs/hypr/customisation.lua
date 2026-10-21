-- Migré depuis customisation.conf

-- Monitors
hl.monitor({ output = "eDP-1", mode = "2880x1920@60", position = "auto", scale = 2 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
-- Stock monitors sets GDK_SCALE=2 for retina displays; override it back to 1
hl.env("GDK_SCALE", "1")

-- Input
hl.config({
	input = {
		kb_layout = "bepoDev",
		kb_options = "lv3:caps_switch", -- ,grp:alts_toggle
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

o.bind("ALT + LEFT", "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))
o.bind("ALT + RIGHT", "Next workspace", hl.dsp.focus({ workspace = "e+1" }))

o.bind("ALT + SHIFT + RIGHT", nil, hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
o.bind("ALT + SHIFT + LEFT", nil, hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
o.bind("ALT + SHIFT + UP", nil, hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
o.bind("ALT + SHIFT + DOWN", nil, hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })

hl.unbind("ALT + SHIFT + code:13")
o.bind("ALT + SHIFT + code:13", nil, "omarchy-menu summon capture")

-- Redimensionner en tirant les bordures, en tiling comme en floating (comme upstream).
hl.config({ general = { resize_on_border = true, extend_border_grab_area = 8 } })

-- Mode floating sur SUPER + L (backport minimal d'Omarchy quattro,
-- default/hypr/workspace-modes.lua) : le cycle devient dwindle → scrolling →
-- floating. En floating, toutes les fenêtres
-- du workspace flottent ; le layout tilé est gardé pour le retour.
--
-- Les fenêtres que le mode fait flotter sont taguées, pour ne retiler qu'elles : une
-- fenêtre qui flottait déjà (dialogue, SUPER + T...) reste flottante. Le layout tilé
-- est sauvegardé comme le fait le script d'origine, les workspaces flottants dans
-- leur propre fichier.
do
	local FLOATED_TAG = "vb-ws-floated"
	local STATE_DIR = (os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state")) .. "/omarchy"
	local FLOATING_FILE = STATE_DIR .. "/floating-workspaces"
	local floating = {}
	local cascade = 0

	local file = io.open(FLOATING_FILE, "r")
	if file then
		for line in file:lines() do
			local id = tonumber(line)
			if id and id >= 1 then
				floating[id] = true
			end
		end
		file:close()
	end

	local function claim(window, on)
		hl.dispatch(hl.dsp.window.tag({ tag = (on and "+" or "-") .. FLOATED_TAG, window = window }))
	end

	local function set_floating(window, on)
		hl.dispatch(hl.dsp.window.float({ action = on and "on" or "off", window = window }))
	end

	local function claimed(window)
		for _, tag in ipairs(window.tags or {}) do
			if tag == FLOATED_TAG then
				return true
			end
		end
		return false
	end

	-- Taille confortable, centrée, décalée en cascade pour ne pas empiler les fenêtres.
	local function place(window)
		local monitor = window.monitor
		if not monitor or not monitor.width then
			return
		end

		local width = math.floor(monitor.width / monitor.scale)
		local height = math.floor(monitor.height / monitor.scale)
		if (monitor.transform or 0) % 2 == 1 then
			width, height = height, width
		end

		hl.dispatch(hl.dsp.window.resize({
			x = math.min(1100, math.floor(width * 0.64)),
			y = math.min(760, math.floor(height * 0.68)),
			relative = false,
			window = window,
		}))
		hl.dispatch(hl.dsp.window.center({ window = window }))

		cascade = (cascade + 1) % 5
		hl.dispatch(hl.dsp.window.move({ x = cascade * 24 - 48, y = cascade * 24 - 48, relative = true, window = window }))
	end

	-- Tout est tagué avant de faire flotter quoi que ce soit : faire flotter un membre
	-- d'un groupe fait flotter tout le groupe, qui serait sinon vu comme déjà flottant.
	local function float_windows(windows)
		local claiming = {}
		-- Boucle sur #windows et pas ipairs : le scanner d'omarchy-menu-keybindings remplace
		-- hl par un proxy dont chaque index est non nil, et ipairs n'y finirait jamais.
		for i = 1, #windows do
			local window = windows[i]
			if not window.floating and (window.fullscreen or 0) == 0 then
				claim(window, true)
				table.insert(claiming, window)
			end
		end
		for _, window in ipairs(claiming) do
			set_floating(window, true)
			place(window)
		end
	end

	-- Une fenêtre épinglée est laissée telle quelle : la retiler la désépinglerait.
	local function tile_window(window)
		if claimed(window) then
			claim(window, false)
			if not window.pinned then
				set_floating(window, false)
			end
		end
	end

	local function save_floating()
		os.execute("mkdir -p '" .. STATE_DIR .. "'")
		local out = io.open(FLOATING_FILE, "w")
		if not out then
			return false
		end
		for id in pairs(floating) do
			out:write(id, "\n")
		end
		out:close()
		return true
	end

	-- Même fichier et même format que le script d'origine, rechargés au démarrage
	-- par default/hypr/workspace-layouts.lua.
	local function save_layout(id, layout)
		local dir = STATE_DIR .. "/workspace-layouts"
		os.execute("mkdir -p '" .. dir .. "'")
		local out = io.open(dir .. "/" .. id .. ".lua", "w")
		if not out then
			return false
		end
		out:write(string.format('hl.workspace_rule({ workspace = "%d", layout = "%s" })\n', id, layout))
		out:close()
		return true
	end

	local NEXT = { dwindle = "scrolling", scrolling = "floating", floating = "dwindle" }

	local function cycle()
		local workspace = hl.get_active_workspace()
		local id = workspace and tonumber(workspace.id)
		-- Les workspaces nommés ou spéciaux ont un id négatif.
		if not id or id < 1 then
			return
		end

		local current = floating[id] and "floating" or (workspace.tiled_layout == "scrolling" and "scrolling" or "dwindle")
		local mode = NEXT[current]
		local windows = hl.get_workspace_windows(tostring(id))
		local saved

		if mode == "floating" then
			floating[id] = true
			float_windows(windows)
			saved = save_floating()
		else
			if floating[id] then
				floating[id] = nil
				for _, window in ipairs(windows) do
					tile_window(window)
				end
				save_floating()
			end
			hl.workspace_rule({ workspace = tostring(id), layout = mode })
			saved = save_layout(id, mode)
		end

		local message = "Workspace layout set to " .. mode
		if not saved then
			message = message .. " (not saved)"
		end
		hl.exec_cmd("omarchy-notification-send -g 󱂬 '" .. message .. "'")
	end

	hl.unbind("SUPER + L")
	o.bind("SUPER + L", "Cycle workspace layout", cycle)

	-- Au chargement (login ou reload), les fenêtres déjà ouvertes sur un workspace
	-- flottant flottent ; celles qui s'ouvriront sont prises par window.open.
	for id in pairs(floating) do
		float_windows(hl.get_workspace_windows(tostring(id)))
	end

	-- Une fenêtre qui s'ouvre sur un workspace flottant flotte aussi.
	hl.on("window.open", function(window)
		local id = window.workspace and tonumber(window.workspace.id)
		if id and floating[id] then
			float_windows({ window })
		end
	end)

	-- Une fenêtre amenée sur un workspace flottant flotte, une fenêtre que le mode a
	-- fait flotter et qui part vers un workspace tilé est retilée. Le déplacement doit
	-- d'abord aboutir, sinon changer l'état flottant l'annule.
	hl.on("window.move_to_workspace", function(window, workspace)
		hl.timer(function()
			local id = workspace and tonumber(workspace.id)
			if id and floating[id] then
				float_windows({ window })
			else
				tile_window(window)
			end
		end, { type = "oneshot", timeout = 1 })
	end)

	-- Barres de titre sur les fenêtres que le mode fait flotter, avec le plugin
	-- d'upstream (omarchy-hyprland-titlebars 0.2.2, extrait du dépôt edge). Il est
	-- compilé pour Hyprland 0.56.2 exactement : après une mise à jour de Hyprland il
	-- ne charge plus, et les fenêtres restent simplement sans barre.
	local TITLEBARS = os.getenv("HOME") .. "/.local/lib/omarchy-hyprland-titlebars/titlebars.so"

	local function theme_colors()
		local colors = {}
		local theme = io.open(os.getenv("HOME") .. "/.local/state/omarchy/current/theme/colors.toml", "r")
		if theme then
			for line in theme:lines() do
				local key, value = line:match('^%s*([%w_]+)%s*=%s*"#(%x%x%x%x%x%x)"')
				if key then
					colors[key] = "rgb(" .. value .. ")"
				end
			end
			theme:close()
		end

		local background = colors.background or "rgb(1a1b26)"
		-- Une barre de la couleur du fond se confond avec la fenêtre.
		local titlebar = colors.lighter_background
		if not titlebar or titlebar == background then
			titlebar = colors.selection or background
		end

		return { foreground = colors.foreground or "rgb(c0caf5)", titlebar = titlebar }
	end

	local plugin = io.open(TITLEBARS, "r")
	if plugin then
		plugin:close()
		pcall(hl.plugin.load, TITLEBARS)
	end

	if hl.plugin.hyprbars then
		local colors = theme_colors()
		local window = [[window = "address:%WINDOW%"]]
		local maximize = "hyprctl dispatch 'hl.dsp.window.fullscreen({ mode = \"maximized\", action = \"toggle\", " .. window .. " })'"

		hl.config({
			plugin = {
				hyprbars = {
					enabled = true,
					workspace_tag = FLOATED_TAG,
					bar_height = 30,
					bar_color = colors.titlebar,
					col = { text = colors.foreground },
					bar_text_font = "monospace",
					bar_text_size = 12,
					bar_text_weight = "normal",
					bar_text_align = "left",
					bar_buttons_alignment = "right",
					bar_part_of_window = true,
					bar_precedence_over_border = true,
					bar_padding = 10,
					bar_button_padding = 8,
					button_rounding = 0,
					icon_on_hover = false,
					inactive_button_color = colors.titlebar,
					on_double_click = maximize,
				},
			},
		})

		for _, button in ipairs({
			{ icon = "×", action = "hyprctl dispatch 'hl.dsp.window.close({ " .. window .. " })'" },
			{ icon = "□", action = maximize },
		}) do
			hl.plugin.hyprbars.add_button({
				bg_color = colors.titlebar,
				fg_color = colors.foreground,
				size = 20,
				icon = button.icon,
				action = button.action,
			})
		end
	end
end
