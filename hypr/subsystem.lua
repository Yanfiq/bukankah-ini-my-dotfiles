-- require("windows_unbinds_intermediary")

hl.on("window.active", function(w)
  -- hl.notification.create({ text = "Window focused: " .. w.class, timeout = 5000, icon = "ok" })
  hl.unbind("SUPER + E")
  hl.unbind("SUPER + I")
  if w.class == "looking-glass-client" then
    -- hl.notification.create({ text = "looking-glass focused" .. w.class, timeout = 5000, icon = "ok" })
    -- local file = io.open("windows_unbinds_intermediary.lua", "w")
    -- if file then
    --   file:write("require\\(\"windows_unbinds_intermediary\"\\)")
    --   file:close()
    -- end
    -- hl.dsp.exec_cmd("echo \"require\\(windows_unbind\\)\" > ~/.config/hypr/windows_unbinds_intermediary.lua")
    hl.unbind("SUPER + E")
    hl.unbind("SUPER + I")
  else
    -- hl.dsp.exec_cmd("cat /dev/null > ~/.config/hypr/windows_unbinds_intermediary.lua")
    -- local file = io.open("windows_unbinds_intermediary.lua", "w")
    -- if file then
    --   file:write("")
    --   file:close()
    -- end
    hl.bind("SUPER + E", hl.dsp.exec_cmd("dolphin"))
    hl.bind("SUPER + I", hl.dsp.exec_cmd("noctalia msg settings-toggle"))
  end
end)
