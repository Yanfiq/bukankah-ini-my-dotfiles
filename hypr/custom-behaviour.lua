hl.on("window.active", function(w)
  -- hl.notification.create({ text = "Window focused: " .. w.class, timeout = 5000, icon = "ok" })
  if w.class == "looking-glass-client" then

    hl.unbind("SUPER + E")
    hl.unbind("SUPER + I")
    local file, err = os.remove(".windows-notfocused.lock")
    if file then
    end
  else
    -- check if the lockfile exists
    local file, err = io.open(".windows-notfocused.lock", "r")
    if file then
      file:close()
      return
    end

    hl.bind("SUPER + E", hl.dsp.exec_cmd("dolphin"))
    hl.bind("SUPER + I", hl.dsp.exec_cmd("noctalia msg settings-toggle"))
    -- create lockfile
    file, err = io.open(".windows-notfocused.lock", "w")
    if file then
      file:close()
    end
  end
end)

-- local fragileMonitor = "eDP-1"
-- local timeout = 10000
-- local blackoutCountdown = hl.timer(function()
--   hl.notification.create({ text = "monitor mati", timeout = 5000, icon = "ok" })
--   hl.dispatch(hl.dsp.exec_raw("pgrep -f '^feh .*--title=blackout' >/dev/null || { feh ~/Pictures/black.png --image-bg='#000000' --title=blackout & disown; sleep 0.5; hyprctl eval 'hl.dispatch(hl.dsp.window.fullscreen({window=\"title:blackout\"}))'; }"))
-- end, { timeout = timeout, type = "oneshot" })
-- -- blackoutCountdown:set_enabled(false)

-- hl.on("monitor.focused", function (m)
--   if m.name ~= fragileMonitor then
--     blackoutCountdown = hl.timer(function()
--       hl.dispatch(hl.dsp.exec_raw("pgrep -f '^feh .*--title=blackout' >/dev/null || { feh ~/Pictures/black.png --image-bg='#000000' --title=blackout & disown; sleep 0.5; hyprctl eval 'hl.dispatch(hl.dsp.window.fullscreen({window=\"title:blackout\"}))'; }"))
--     end, { timeout = timeout, type = "oneshot" })
--     blackoutCountdown:set_enabled(true)
--   else
--     blackoutCountdown:set_enabled(false)
--     hl.dispatch(hl.dsp.exec_cmd('pkill -f "feh /home/ryanfikri/Pictures/black.png --image-bg=#000000 --title=blackout"'))
--   end
-- end)
