local TreeLogic = {

    TreeStats = {},
    BoughtNodeIndexes = {}

}

local TreeStats = {}

TreeLogic.TreeStats[1] = {
    x = 0,
    y = 0,
    stats = {
        '4% Increased HP', 'hp_multiplier', 0.04,
        '4% Increased Ammo', 'ammo_multiplier', 0.04
    },
    links = { 2 }
}
TreeLogic.TreeStats[2] = { x = 32, y = 0, stats = { '6% Increased HP', 'hp_multiplier', 0.04 }, links = { 1, 3 } }
TreeLogic.TreeStats[3] = { x = 32, y = 32, stats = { '4% Increased HP', 'hp_multiplier', 0.04 }, links = { 2 } }

TreeLogic.BoughtNodeIndexes= {1,3}


return TreeLogic