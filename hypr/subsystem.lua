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
