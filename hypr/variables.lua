-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 4,

        border_size = 2,

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = true,

        layout = "scrolling",
    },

    decoration = {
        rounding       = 5,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "0xee1a1a1a",
        },

        blur = {
            enabled   = true,
            size      = 5,
            passes    = 2,
            vibrancy  = 0.1696,
        },

        motion_blur = {
            enabled = true,
            samples = 7
        },
    },

    xwayland = {
        use_nearest_neighbor = false
    },

    cursor = {
        persistent_warps = true
    },

    animations = {
        enabled = true,
    },

    scrolling = {
        follow_focus = false,
        wrap_focus = false,
        wrap_swapcol = false,
        fullscreen_on_one_column = false,
        focus_fit_method = 1,
    },

    -- ["decoration.blur.enabled"] = false

})


-- plugins
if hl.plugin and hl.plugin.scrolloverview then
    hl.config({
        plugin = {
            scrolloverview = {
                gesture_distance = 300,
                scale = 0.3,
                workspace_gap = 50,
                layout = "vertical",
                wallpaper = 2,
                blur = true,
                cross_monitor_drag = true,
                shadow = {
                    enabled = false,
                    range = 50,
                    render_power = 3,
                    color = 0xee1a1a1a,
                },
            }
        }
    })
end

