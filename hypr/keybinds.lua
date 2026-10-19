---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local utils = require("utils")

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for moreTriggerCharacter
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("dolphin"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("wl-mirror $(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')"))                        -- quick mirror

hl.bind(mainMod .. " + Tab", function()
    hl.plugin.scrolloverview.overview("toggle all")
end)

-- window state
hl.bind(mainMod .. " + ALT + Space", function ()
    -- local activeWindow = hl.get_active_window().pid
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    hl.dispatch(hl.dsp.window.pin({ action = "toggle" }))
    -- hl.dispatch(hl.dsp.focus({ window = "pid:" .. activeWindow }))
end)
hl.bind(mainMod .. " + D", function ()
    hl.dispatch(hl.dsp.window.fullscreen({mode = "maximized", action = "toggle", layout_aware = true}))
    hl.dispatch(hl.dsp.window.pin({ action = "disable" }))
end)
hl.bind(mainMod .. " + F", function ()
    hl.dispatch(hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle", layout_aware = true }))
    hl.dispatch(hl.dsp.window.pin({ action = "disable" }))
end)

-- Window focus
hl.bind(mainMod .. " + left", function ()
    local window, window_at = utils.get_active_window_position()
    local monitor, monitor_at = utils.get_active_monitor_position()
    if not window or not window_at or not monitor or not monitor_at then return end

    -- pinggir kiri monitor
    local left_constraint = monitor_at.x

    -- Kalo activewindow gk keliatan full (posisi x negatif karena di luar viewport), fit windownya ke viewport, 
    if window.visible and window_at.x - left_constraint < 0 then
        hl.dispatch(hl.dsp.layout("fit_into_view"))
    else
        -- else, fokus ke window sebelah kiri
        hl.dispatch(hl.dsp.layout("focus l"))
    end
end)
hl.bind(mainMod .. " + right", function ()
    local window, window_at = utils.get_active_window_position()
    local _, window_size = utils.get_active_window_size()
    local monitor, monitor_at = utils.get_active_monitor_position()
    local _, monitor_size, monitor_scale = utils.get_active_monitor_size_and_scale()
    if not window or not window_at or not window_size or not monitor or not monitor_at or not monitor_size or not monitor_scale then return end

    -- pinggir kanan monitor
    local right_constraint = monitor_size.x + monitor_at.x
    local window_right_edge = window_at.x + window_size.x -- pinggir kanan window

    -- kalo activewindow gk keliatan full (posisi x + size x lebih besar dari pinggir kanan monitor), fit windownya ke viewport,
    if window.visible and window_right_edge >= right_constraint then
        hl.dispatch(hl.dsp.layout("fit_into_view"))
    else
        hl.dispatch(hl.dsp.layout("focus r"))
    end
end)
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- window movement
hl.bind(mainMod .. " + CTRL + SHIFT + left", hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + CTRL + SHIFT + right", hl.dsp.layout("swapcol r"))
hl.bind(mainMod .. " + SHIFT + left", function ()
    local isItFloating = hl.get_active_window().floating
    if isItFloating then
        hl.dispatch(hl.dsp.window.move({ x = -100, y = 0, relative = true }))
    else
        hl.dispatch(hl.dsp.layout("consume_or_expel prev"))
    end
end)
hl.bind(mainMod .. " + SHIFT + right", function ()
    local isItFloating = hl.get_active_window().floating
    if isItFloating then
        hl.dispatch(hl.dsp.window.move({ x = 100, y = 0, relative = true }))
    else
        hl.dispatch(hl.dsp.layout("consume_or_expel next"))
    end
end)
hl.bind(mainMod .. " + SHIFT + up", function()
    local window, window_at = utils.get_active_window_position()
    local monitor, monitor_size, monitor_scale = utils.get_active_monitor_size_and_scale()
    local _, monitor_at = utils.get_active_monitor_position()
    local border_size = hl.get_config("general.border_size")
    local gaps_out = hl.get_config("general.gaps_out").top
    if not window or not window_at or not monitor or not monitor_size or not monitor_scale or not monitor_at then return end

    local reserved_top = monitor.reserved.top
    local top_constraint = monitor_at.y + reserved_top + gaps_out
    local window_top_edge = window_at.y - border_size -- pinggir atas window

    local isItUpperMost = window_top_edge <= top_constraint
    local isItFloating = window.floating

    hl.notification.create({ text = tostring(window_top_edge .. " | " .. top_constraint), timeout = 5000, icon = "ok" })

    if isItUpperMost then
        hl.dispatch(hl.dsp.window.move({ workspace = "r-1" }))
    else
        if isItFloating then
            hl.dispatch(hl.dsp.window.move({ y = -100, x = 0, relative = true }))
        else
            hl.dispatch(hl.dsp.window.move({ direction = "u" }))
        end
    end
end)
hl.bind(mainMod .. " + SHIFT + down", function()
    local window, window_at = utils.get_active_window_position()
    local _, window_size = utils.get_active_window_size()
    local monitor, monitor_size, monitor_scale = utils.get_active_monitor_size_and_scale()
    local _, monitor_at = utils.get_active_monitor_position()
    if not window or not window_at or not window_size or not monitor or not monitor_size or not monitor_scale or not monitor_at then return end

    local reserved_top = monitor.reserved.top
    local bottom_constraint = monitor_size.y
    local window_bottom_edge = window_at.y + window_size.y + reserved_top -- pinggir bawah window

    local isItLowerMost = window_bottom_edge >= bottom_constraint
    local isItFloating = window.floating

    hl.notification.create({ text = tostring(window_bottom_edge .. " | " .. bottom_constraint), timeout = 5000, icon = "ok" })

    if isItLowerMost then
        hl.dispatch(hl.dsp.window.move({ workspace = "r+1" }))
    else
        if isItFloating then
            hl.dispatch(hl.dsp.window.move({ y = 100, x = 0, relative = true }))
        else
            hl.dispatch(hl.dsp.window.move({ direction = "d" }))
        end
    end
end)
hl.bind(mainMod .. " + SHIFT + ALT + left", function ()
    hl.dispatch(hl.dsp.window.move({ monitor = "-1" }))
end)
hl.bind(mainMod .. " + SHIFT + ALT + right", function ()
    hl.dispatch(hl.dsp.window.move({ monitor = "+1" }))
end)

hl.bind("SHIFT + ALT + left", hl.dsp.workspace.move({ monitor = "-1" }))
hl.bind("SHIFT + ALT + right", hl.dsp.workspace.move({ monitor = "+1" }))
hl.bind("SHIFT + ALT + up", function()
    local currentWorkspace = hl.get_active_workspace().id
    local isExternalMonitorPluggedIn = hl.get_monitor("HDMI-A-1") and true or false
    local previousWorkspace = currentWorkspace - (isExternalMonitorPluggedIn and 2 or 1)
    if currentWorkspace == 1 or (isExternalMonitorPluggedIn and currentWorkspace == 2) then return end
    hl.dispatch(hl.dsp.workspace.change_id({ workspace = previousWorkspace, id = 1000 }))
    hl.dispatch(hl.dsp.workspace.change_id({ workspace = currentWorkspace, id = previousWorkspace }))
    hl.dispatch(hl.dsp.workspace.change_id({ workspace = 1000, id = currentWorkspace }))
    --   hl.notification.create({ text = tostring("Switched " .. currentWorkspace .. " to workspace " .. previousWorkspace), timeout = 5000 })
end)
hl.bind("SHIFT + ALT + down", function()
    local currentWorkspace = hl.get_active_workspace().id
    local isExternalMonitorPluggedIn = hl.get_monitor("HDMI-A-1") and true or false
    local nextWorkspace = currentWorkspace + (isExternalMonitorPluggedIn and 2 or 1)
    hl.dispatch(hl.dsp.workspace.change_id({ workspace = nextWorkspace, id = 1000 }))
    hl.dispatch(hl.dsp.workspace.change_id({ workspace = currentWorkspace, id = nextWorkspace }))
    hl.dispatch(hl.dsp.workspace.change_id({ workspace = 1000, id = currentWorkspace }))
    --   hl.notification.create({ text = tostring("Switched " .. currentWorkspace .. " to workspace " .. nextWorkspace), timeout = 5000 })
end)
-- hl.bind(mainMod .. " + SHIFT + ALT + up", function ()
--   local window = hl.get_active_window()
--   local isItUpperMost = window.at
-- end)
-- hl.bind(mainMod .. " + SHIFT + ALT + down", hl.dsp.window.move({ workspace="r+1" }))
-- hl.bind(mainMod .. " + CTRL + left", hl.dsp.layout("colresize -0.05"))
-- hl.bind(mainMod .. " + CTRL + right", hl.dsp.layout("colresize +0.05"))
hl.bind(mainMod .. " + CTRL + left", function ()
    local scale = hl.get_active_monitor().scale
    hl.dispatch(hl.dsp.window.resize({ x = -100 / scale, y = 0, relative = true }))
    -- hl.dispatch(hl.dsp.layout("fit_into_view"))
    -- local isItPreviouslyMaxxedRight = hl.get_active_window().at.x + hl.get_active_window().size.x * scale + hl.get_config("general.gaps_in").right * scale + hl.get_config("general.border_size") * scale + 100/scale >= hl.get_active_monitor().width
    -- if isItPreviouslyMaxxedRight then
    --     hl.dispatch(hl.dsp.layout("move " .. 100 / scale))
    -- end
end, { repeating = true })
hl.bind(mainMod .. " + CTRL + right", function ()
    local scale = hl.get_active_monitor().scale
    -- local isItMaxxedRight = hl.get_active_window().at.x * scale + hl.get_active_window().size.x * scale + hl.get_config("general.gaps_in").right * scale + hl.get_config("general.border_size") * scale >= hl.get_active_monitor().width
    -- if isItMaxxedRight then
    --     -- hl.dispatch(hl.dsp.window.move({ x = -100 / scale, y = 0, relative = true }))
    --     hl.dispatch(hl.dsp.layout("move " .. -100 / scale))
    -- end
    hl.dispatch(hl.dsp.window.resize({ x = 100 / scale, y = 0, relative = true }))
end, { repeating = true })
hl.bind(mainMod .. " + CTRL + up", function ()
    local scale = hl.get_active_monitor().scale
    hl.dispatch(hl.dsp.window.resize({ x = 0, y = 100 / scale, relative = true }))
end, { repeating = true })
hl.bind(mainMod .. " + CTRL + down", function ()
    local scale = hl.get_active_monitor().scale
    hl.dispatch(hl.dsp.window.resize({ x = 0, y = -100 / scale, relative = true }))
end, { repeating = true })

-- noctalia
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("noctalia msg settings-toggle"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("noctalia msg session lock"))
-- hl.bind(mainMod .. " + SUPER_L", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center"))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + ALT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
-- hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("noctalia msg screenshot-region"))


-- -- Scroll through existing workspaces with mainMod + scroll
-- hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "r+1", on_current_monitor = true }))
-- hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "r-1", on_current_monitor = true }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
-- hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
-- hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
-- hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
-- hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia msg volume-mute"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", function ()
    hl.dispatch(hl.dsp.exec_cmd("noctalia msg mic-mute"))
    hl.dispatch(hl.dsp.exec_cmd("brightnessctl -d platform::micmute set $(( $(brightnessctl -d platform::micmute get) ^ 1 ))"))
end, { locked = true, repeating = true }
)

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- workspaces
hl.bind("ALT + down", hl.dsp.focus({ workspace = "r+1", on_current_monitor = true }))
hl.bind("ALT + up", hl.dsp.focus({ workspace = "r-1", on_current_monitor = true }))

-- switch monitor's focus
hl.bind("ALT + right", hl.dsp.focus({ monitor = "r" }))
hl.bind("ALT + left", hl.dsp.focus({ monitor = "l" }))
