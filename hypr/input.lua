---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",
        repeat_delay = 250,
        repeat_rate = 50,

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = true,
        },
    },

    gestures = {
        scrolling = {
            move_snap_to_grid = true
        }
    }
})

-- hl.gesture({
--     fingers = 3,
--     direction = "vertical",
--     action = "workspace"
-- })

-- local move_view = function(change)
--     local natural_change = math.floor(change) * 15
--     hl.dispatch(hl.dsp.layout("move " .. natural_change))
--     -- hl.notification.create({ text = "move " .. natural_change, timeout = 1000, icon = 1})
-- end

-- hl.gesture({
--     fingers = 3,
--     direction = "horizontal",
--     action = "scroll_move"
-- })

-- hl.gesture({
--     fingers = 3,
--     direction = "horizontal",
--     action = {
--         start = function (e) hl.dsp.window.fullscreen_state({ internal=-1, client=0, action=set, layout_aware=true}) end,
--         update = function (e) move_view(e.delta.x) end
--     }
-- })
