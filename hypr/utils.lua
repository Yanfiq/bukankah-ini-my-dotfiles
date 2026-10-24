local M = {}

local function get_active_window_position()
    local window = hl.get_active_window()
    if not window or not window.at then return nil end

    local at = window.at and 
    type(window.at) == "table" and {
        x = window.at.x,
        y = window.at.y
    } or
    type(window.at) == "number" and {
        x = window.at,
        y = window.at
    }

    return window, at
end

local function get_active_window_size()
    local window = hl.get_active_window()
    if not window or not window.size then return nil end

    local size = window.size and 
    type(window.size) == "table" and {
        x = window.size.x,
        y = window.size.y
    } or
    type(window.size) == "number" and {
        x = window.size,
        y = window.size
    }

    return window, size
end

local function get_active_monitor_position()
    local monitor = hl.get_active_monitor()
    if not monitor or not monitor.position then return nil end

    local position = monitor.position and
    type(monitor.position) == "table" and {
        x = monitor.position.x,
        y = monitor.position.y
    } or
    type(monitor.position) == "number" and {
        x = monitor.position,
        y = monitor.position
    }

    return monitor, position
end

local function get_active_monitor_size_and_scale()
    local monitor = hl.get_active_monitor()
    if not monitor then return nil end

    local size = {
        x = monitor.width / monitor.scale,
        y = monitor.height / monitor.scale
    }

    return monitor, size, monitor.scale
end

local function get_monitor_dependent_tollerance()
    local monitor = hl.get_active_monitor()
    if not monitor or not monitor.scale then return nil end

    local scale = monitor.scale
    local tolerance = 1 / scale

    return tolerance
end

M.get_active_window_position = get_active_window_position
M.get_active_window_size = get_active_window_size
M.get_active_monitor_position = get_active_monitor_position
M.get_active_monitor_size_and_scale = get_active_monitor_size_and_scale
M.get_monitor_dependent_tollerance = get_monitor_dependent_tollerance
return M
