-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "2560x1440@144",
    position = "auto",
    scale    = "auto",
})

hl.monitor({
    output   = "eDP-1",
    mode     = "2880x1800@90",
    position = "0x600",
    scale    = "1.8",
    -- bitdepth = 10,
    -- cm       = "hdr"
    -- disabled = true
})
