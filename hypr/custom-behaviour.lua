-- require("windows_unbinds_intermediary")

hl.on("window.active", function(w)
  -- hl.notification.create({ text = "Window focused: " .. w.class, timeout = 5000, icon = "ok" })
  if w.class == "looking-glass-client" then
    -- hl.notification.create({ text = "looking-glass focused, unbind", timeout = 5000, icon = "ok" })

    hl.unbind("SUPER + E")
    hl.unbind("SUPER + I")
    local file, err = os.remove(".windows-notfocused.lock")
    if file then
      -- hl.notification.create({ text = "lockfile removed", timeout = 5000 })
    end
  else
    -- check if the lockfile exists
    local file, err = io.open(".windows-notfocused.lock", "r")
    if file then
      file:close()
      -- hl.notification.create({ text = "looking-glass still not focused, skip rebind", timeout = 5000 })
      return
    end

    -- hl.notification.create({ text = "looking-glass not focused, rebind", timeout = 5000 })
    hl.bind("SUPER + E", hl.dsp.exec_cmd("dolphin"))
    hl.bind("SUPER + I", hl.dsp.exec_cmd("noctalia msg settings-toggle"))
    -- create lockfile
    file, err = io.open(".windows-notfocused.lock", "w")
    if file then
      file:close()
      -- hl.notification.create({ text = "lockfile created", timeout = 5000 })
    end
  end
end)

-- local fragileMonitor = "eDP-1"
-- local timeout = 10000
-- local blackoutCountdown = hl.timer(function()
--   hl.notification.create({ text = "monitor mati", timeout = 5000, icon = "ok" })
--   -- hl.dispatch(hl.dsp.exec_cmd("brightnessctl -damdgpu_bl1 get > /tmp/last_brightneess && brightnessctl -damdgpu_bl1 set 0"))
--   -- hl.notification.create({ text = tostring(hl.get_cursor_pos().x) .. ", " .. tostring(hl.get_cursor_pos().y), timeout = 5000, icon = "ok" })
--   hl.dispatch(hl.dsp.exec_raw("pgrep -f '^feh .*--title=blackout' >/dev/null || { feh ~/Pictures/black.png --image-bg='#000000' --title=blackout & disown; sleep 0.5; hyprctl eval 'hl.dispatch(hl.dsp.window.fullscreen({window=\"title:blackout\"}))'; }"))
--   -- hl.dispatch(hl.dsp.window.fullscreen({ window="title:blackout" }))
--   -- hl.notification.create({ text = "[ " .. cursor_pos_x .. ", " .. cursor_pos_y .. " ]", timeout = 5000, icon = "ok" })
-- end, { timeout = timeout, type = "oneshot" })
-- -- blackoutCountdown:set_enabled(false)

-- hl.on("monitor.focused", function (m)
--   -- hl.notification.create({ text = tostring(m.name), timeout = 5000, icon = "ok" })
--   if m.name ~= fragileMonitor then
--     -- blackoutCountdown:set_timeout(timeout)
--     blackoutCountdown:set_enabled(true)
--     -- hl.dispatch(hl.dsp.exec_cmd("brightnessctl -damdgpu_bl1 get > /tmp/last_brightneess"))
--     -- hl.notification.create({ text = "ext mon", timeout = 5000, icon = "ok" })
--   else
--     blackoutCountdown:set_enabled(false)
--     -- hl.dispatch(hl.dsp.exec_cmd("brightnessctl -damdgpu_bl1 set $(cat /tmp/last_brightneess) && echo 0 > /tmp/last_brightneess"))
--     hl.dispatch(hl.dsp.exec_cmd('pkill -f "feh /home/ryanfikri/Pictures/black.png --image-bg=#000000 --title=blackout"'))
--     -- hl.notification.create({ text = "fragile mon", timeout = 5000, icon = "ok" })
--   end
-- end)