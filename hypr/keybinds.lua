---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local customDispatch = require("custom-dispatcher")

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for moreTriggerCharacter
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")) -- exit hyprland
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("dolphin"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("wl-mirror $(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')")) -- quick mirror
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("noctalia msg screenshot-region"))

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
    customDispatch.focus_window_or_fit_into_view("left")
end)
hl.bind(mainMod .. " + right", function ()
    customDispatch.focus_window_or_fit_into_view("right")
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
    customDispatch.move_window_or_move_to_workspace("up")
end)
hl.bind(mainMod .. " + SHIFT + down", function()
    customDispatch.move_window_or_move_to_workspace("down")
end)
hl.bind(mainMod .. " + SHIFT + ALT + left", function ()
    hl.dispatch(hl.dsp.window.move({ monitor = "-1" }))
end)
hl.bind(mainMod .. " + SHIFT + ALT + right", function ()
    hl.dispatch(hl.dsp.window.move({ monitor = "+1" }))
end)

hl.bind("SHIFT + ALT + left", hl.dsp.workspace.move({ monitor = "-1" }))
hl.bind("SHIFT + ALT + right", hl.dsp.workspace.move({ monitor = "+1" }))
hl.bind("SHIFT + ALT + up", function() customDispatch.swap_adjacent_workspaces("prev") end)
hl.bind("SHIFT + ALT + down", function() customDispatch.swap_adjacent_workspaces("next") end)

-- hl.bind(mainMod .. " + CTRL + left", hl.dsp.layout("colresize -0.05"))
-- hl.bind(mainMod .. " + CTRL + right", hl.dsp.layout("colresize +0.05"))
hl.bind(mainMod .. " + CTRL + left", function ()
    hl.dispatch(hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
end, { repeating = true })
hl.bind(mainMod .. " + CTRL + right", function ()
    hl.dispatch(hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
end, { repeating = true })
hl.bind(mainMod .. " + CTRL + up", function ()
    hl.dispatch(hl.dsp.window.resize({ x = 0, y = 100, relative = true }))
end, { repeating = true })
hl.bind(mainMod .. " + CTRL + down", function ()
    hl.dispatch(hl.dsp.window.resize({ x = 0, y = -100, relative = true }))
end, { repeating = true })

-- noctalia
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("noctalia msg settings-toggle"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("noctalia msg session lock"))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + ALT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- -- Scroll through existing workspaces with mainMod + scroll
-- hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "r+1", on_current_monitor = true }))
-- hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "r-1", on_current_monitor = true }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
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

-- switch workspace's focus
hl.bind("ALT + down", hl.dsp.focus({ workspace = "r+1", on_current_monitor = true }))
hl.bind("ALT + up", hl.dsp.focus({ workspace = "r-1", on_current_monitor = true }))

-- switch monitor's focus
hl.bind("ALT + right", hl.dsp.focus({ monitor = "r" }))
hl.bind("ALT + left", hl.dsp.focus({ monitor = "l" }))