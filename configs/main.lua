-- INVENTORY SUPPORTED BY DEFAULT: ox_inventory, qb-inventory, qs-inventory, avp_inv_4

local MAIN <const> = {
    eventFrequency = 1000 * 60 * 60 * 3, -- 3 hours
    eventDuration = 1000 * 60 * 60 * 1, -- 1 hour
    manualCommand = 'starttreasurehunt',
    tpCommand = 'gototreasure', -- Command to teleport to the treasure
    helpText = true,

    rewards = {
        {type = 'item', name = 'water', label = 'Water', amount = 2, chance = 20}, -- 20% chance to get 2 water
        {type = 'money', label = 'Money', amount = 100, chance = 80}, -- 80% chance to get 100 money
        {type = 'weapon', label = 'Pistol', name = 'weapon_pistol', amount = 1, chance = 10}, -- 10% chance to get 1 pistol
        {type = 'car', label = 'Adder', name = 'adder', amount = 1, chance = 5} -- 5% chance to get an adder
        -- ...
    },

    target = {
        enabled = true, -- ox_target and qb-target supported by default
        label = 'Open Treasure',
        icon = 'fa-solid fa-gem',
        distance = 3.0
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
    },
}

return MAIN