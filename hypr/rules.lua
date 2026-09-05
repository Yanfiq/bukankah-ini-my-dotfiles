--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

-- hl.window_rule({
--     name  = "no-titlebar-dragging",
--     match = { class = ".*", float = true },

--     no_xdg_drags = true,
-- })
-- suppressMaximizeRule:set_enabled(false)

-- hl.window_rule({
--     -- Fix some dragging issues with XWayland
--     name  = "fix-xwayland-drags",
--     match = {
--         class      = "^$",
--         title      = "^$",
--         xwayland   = true,
--         float      = true,
--         fullscreen = false,
--         pin        = false,
--     },
--
--     no_focus = true,
-- })

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

hl.window_rule({
    name = "osu-big-monit",
    match = { class = "osu!" },

    monitor = "1",
    fullscreen = true,
    immediate = true
})

hl.window_rule({
    name = "protect-oled",
    match = { title = "blackout" },

    monitor = "eDP-1",
    fullscreen = true,
    -- no_initial_focus = true,
    -- no_anim = true,
})

hl.window_rule({
    name = "file-picker-float",
    match = {
        class = "org.freedesktop.impl.portal.desktop.kde",
        title = "Select File"
    },

    float = true
})

hl.window_rule({
    name = "center-every-float",
    match = {
        float = true
    },
    center = true
})

hl.window_rule({
    name = "hyprland-share-picker",
    match = {
        class = "hyprland-share-picker"
    },

    float = true
})

-- hl.window_rule({
--     name = "looking-glass",
--     match = {
--         class = "looking-glass-client"
--     },
--
--     maximize = true
-- })

-- custom window_rule
hl.on("window.open", function(w)
  -- Perform custom Lua logic when a window becomes active
  if w.class == "looking-glass-client" then
    hl.dispatch(hl.dsp.layout("colresize 1"))
    -- local colWidth = hl.get_active_window().size.x
    -- local monWidth = hl.get_active_monitor().width
    -- local monScale = hl.get_active_monitor().scale
    -- local percentage = colWidth / (monWidth / monScale)
    -- -- hl.notification.create({ text = tostring(percentage), timeout = 2000 })
    -- if not (percentage >= 0.9) then
    --     hl.dispatch(hl.dsp.layout("colresize 1"))
    -- end
  end
end)


hl.layer_rule({
  name = "noctalia",
  match = {
    namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
  },
  no_anim = true,
  ignore_alpha = 0.5,
  blur = true,
  blur_popups = true,
})
hl.window_rule({
    match = { class = "dev.noctalia.Noctalia" },
    float = true,
    size = { 1080, 920 },
})
-- hl.workspace_rule({ workspace = "1", monitor = "eDP-1", persistent = false })
-- hl.workspace_rule({ workspace = "3", monitor = "eDP-1", persistent = false })
-- hl.workspace_rule({ workspace = "5", monitor = "eDP-1", persistent = false })
-- hl.workspace_rule({ workspace = "7", monitor = "eDP-1", persistent = false })
-- hl.workspace_rule({ workspace = "9", monitor = "eDP-1", persistent = false })
-- hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1", persistent = false })
-- hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-1", persistent = false })
-- hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1", persistent = false })
-- hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1", persistent = false })
-- hl.workspace_rule({ workspace = "10", monitor = "HDMI-A-1", persistent = false })

for i = 1, 100 do
  local odd = i % 2 == 1
  if odd then
    hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1", persistent = false })
  else
    hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1", persistent = false })
  end
end

-- hl.workspace_rule({ workspace = "11", monitor = "eDP-1", persistent = false })
-- hl.workspace_rule({ workspace = "13", monitor = "eDP-1", persistent = false })
-- hl.workspace_rule({ workspace = "8", monitor = "eDP-1", persistent = false })
-- hl.workspace_rule({ workspace = "9", monitor = "eDP-1", persistent = false })
-- hl.workspace_rule({ workspace = "10", monitor = "eDP-1", persistent = false })
-- hl.workspace_rule({ workspace = "16", monitor = "HDMI-A-1", persistent = false })
-- hl.workspace_rule({ workspace = "17", monitor = "HDMI-A-1", persistent = false })
-- hl.workspace_rule({ workspace = "18", monitor = "HDMI-A-1", persistent = false })
-- hl.workspace_rule({ workspace = "19", monitor = "HDMI-A-1", persistent = false })
-- hl.workspace_rule({ workspace = "20", monitor = "HDMI-A-1", persistent = false })
