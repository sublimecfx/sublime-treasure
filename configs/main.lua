local MAIN <const> = {
    eventFrequency = 1000 * 60 * 60 * 3, -- 3 hours
    eventDuration = 1000 * 60 * 60 * 1, -- 1 hour
    clueSentTime = 1000 * 60 * 10, -- 10 minutes

    manualCommand = 'starttreasurehunt',
    target = 'ox_target', -- ox_target or qb-target

    rewards = {
        {type = 'item', name = 'water', amount = 2, chance = 20},
        {type = 'money', amount = 100, chance = 80},
        {type = 'weapon', name = 'weapon_pistol', amount = 1, chance = 10},
        {type = 'car', name = 'adder', chance = 5}
        -- ...
    },

    blip = {
        enabled = true,
        colour = 5,
        alpha = 125,
        sprite = 835,
        scale = 0.7
    },

    treasureEntity = {
        model = {
            closed = 'prop_box_wood05a',
            opened = 'prop_box_wood05b'
        },
        frozen = true, 
        invulnerable = true,
        collision = true
    }
}

return MAIN