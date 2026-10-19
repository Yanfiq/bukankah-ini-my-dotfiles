local M = {}

local utils = require("utils")

local function focus_window_or_fit_into_view(direction)
    local window, window_at = utils.get_active_window_position()
    local _, window_size = utils.get_active_window_size()
    local monitor, monitor_at = utils.get_active_monitor_position()
    local _, monitor_size, _ = utils.get_active_monitor_size_and_scale()
    if not window or not window_at or not window_size or not monitor or not monitor_at  or not monitor_size then return end

    if direction == "left" then
        -- pinggir kiri monitor
        local left_constraint = monitor_at.x
    
        -- Kalo activewindow gk keliatan full (posisi x negatif karena di luar viewport), fit windownya ke viewport, 
        if window.visible and window_at.x - left_constraint < 0 then
            hl.dispatch(hl.dsp.layout("fit_into_view"))
        else
            -- else, fokus ke window sebelah kiri
            hl.dispatch(hl.dsp.layout("focus l"))
        end
    elseif direction == "right" then
        -- pinggir kanan monitor
        local right_constraint = monitor_size.x + monitor_at.x
        local window_right_edge = window_at.x + window_size.x -- pinggir kanan window
    
        -- kalo activewindow gk keliatan full (posisi x + size x lebih besar dari pinggir kanan monitor), fit windownya ke viewport,
        if window.visible and window_right_edge >= right_constraint then
            hl.dispatch(hl.dsp.layout("fit_into_view"))
        else
            hl.dispatch(hl.dsp.layout("focus r"))
        end
    end
end

local function move_window_or_move_to_workspace(direction)
    local window, window_at = utils.get_active_window_position()
    local _, window_size = utils.get_active_window_size()
    local monitor, monitor_size, monitor_scale = utils.get_active_monitor_size_and_scale()
    local _, monitor_at = utils.get_active_monitor_position()
    local border_size = hl.get_config("general.border_size")
    local gaps_out = hl.get_config("general.gaps_out").top
    if not window or not window_size or not window_at then return end
    if not monitor or not monitor_size or not monitor_scale or not monitor_at then return end

    if direction == "up" then
        local reserved_top = monitor.reserved.top
        local top_constraint = monitor_at.y + reserved_top + gaps_out
        local window_top_edge = window_at.y - border_size -- pinggir atas window
    
        local isItUpperMost = window_top_edge <= top_constraint
        local isItFloating = window.floating
    
        -- hl.notification.create({ text = tostring(window_top_edge .. " | " .. top_constraint), timeout = 5000, icon = "ok" })
    
        if isItUpperMost then
            hl.dispatch(hl.dsp.window.move({ workspace = "r-1" }))
        else
            if isItFloating then
                hl.dispatch(hl.dsp.window.move({ y = -100, x = 0, relative = true }))
            else
                hl.dispatch(hl.dsp.window.move({ direction = "u" }))
            end
        end
    elseif direction == "down" then
        local reserved_top = monitor.reserved.top
        local bottom_constraint = monitor_size.y
        local window_bottom_edge = window_at.y + window_size.y + reserved_top -- pinggir bawah window

        local isItLowerMost = window_bottom_edge >= bottom_constraint
        local isItFloating = window.floating
    
        -- hl.notification.create({ text = tostring(window_bottom_edge .. " | " .. bottom_constraint), timeout = 5000, icon = "ok" })
    
        if isItLowerMost then
            hl.dispatch(hl.dsp.window.move({ workspace = "r+1" }))
        else
            if isItFloating then
                hl.dispatch(hl.dsp.window.move({ y = 100, x = 0, relative = true }))
            else
                hl.dispatch(hl.dsp.window.move({ direction = "d" }))
            end
        end
    end
end

M.focus_window_or_fit_into_view = focus_window_or_fit_into_view
M.move_window_or_move_to_workspace = move_window_or_move_to_workspace

return M