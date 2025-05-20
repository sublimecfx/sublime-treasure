local MAIN <const> = {
    eventFrequency = 1000 * 60 * 60 * 3, -- 3 hours
    eventDuration = 1000 * 60 * 60 * 1, -- 1 hour

    manualCommand = 'starttreasurehunt',
    target = false, -- ox_target and qb-target supported

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
        data = {
            frozen = true,
            collision = true,
            invulnerable = true
        }
    },

    animations = {
        open = {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            anim = 'machinic_loop_mechandplayer',
            duration = 4000
        }
    },

    effects = {
        asset = 'scr_xs_celebration',
        name = 'scr_xs_confetti_burst',
        amount = 5,
        duration = 200
    }
}

return MAIN