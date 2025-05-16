local LOG <const> = {
    enabled = true,
    debug = true,
    info = true,
    
    levels = {
        ["debug"] = "^5",
        ["info"] = "^5"
    }
}

return LOG