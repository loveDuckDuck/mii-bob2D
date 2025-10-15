local TreeLogic = {
    TreeStats = {},
    BoughtNodeIndexes = {}
}

local MAX_POINTS = 1000

-- Multiplier types available
local MULTIPLIER_TYPES = {
    'luck_multiplier',
    'hp_multiplier',
    'damage_multiplier',
    'boost_multiplier',
    'speed_multiplier',
    'mana_multiplier',
    'size_multiplier',
    'projectile_size_multiplier',
    'invulnerability_time_multiplier',
    'turn_rate_multiplier',
    'attack_spawn_rate_multiplier',
    'resource_spawn_rate_multiplier',
    'enemy_spawn_rate_multiplier',
    'friction_multiplier'
}

-- Percentage increases
local MULTIPLIER_VALUES = { 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.10 }

-- Tree structure configuration
local TREE_BRANCHES = 14  -- One per multiplier type
local NODES_PER_BRANCH = 15
local NODE_SPACING = 64
local BRANCH_ANGLE_OFFSET = 100

-- Helper function to generate random percentage
local function getRandomMultiplier()
    return MULTIPLIER_VALUES[math.random(1, #MULTIPLIER_VALUES)]
end

-- Helper function to get random multiplier type
local function getRandomMultiplierType()
    return MULTIPLIER_TYPES[math.random(1, #MULTIPLIER_TYPES)]
end

-- Helper function to convert percentage to display string
local function getStatString(mult_type, percentage)
    local percent_display = math.floor(percentage * 100)
    local friendly_name = mult_type:gsub('_', ' '):gsub('(%w)(%w*)', function(a,b) return string.upper(a)..b end)
    return percent_display .. '% Increased ' .. friendly_name
end

-- Generate skill tree nodes
local function generateSkillTree()
    local node_id = 1
    local angle_step = (2 * math.pi) / TREE_BRANCHES
    
    -- Create root node in center
    TreeLogic.TreeStats[node_id] = {
        x = 0,
        y = 0,
        stats = {},
        links = {}
    }
    node_id = node_id + 1
    
    -- Generate branches radiating from center
    for branch = 1, TREE_BRANCHES do
        local angle = (branch - 1) * angle_step
        local branch_length = NODES_PER_BRANCH
        local prev_node = 1  -- Always links back to root first
        
        for depth = 1, branch_length do
            local distance = depth * NODE_SPACING
            local x = math.cos(angle) * distance
            local y = math.sin(angle) * distance
            
            -- Randomize stat for this node
            local mult_type = MULTIPLIER_TYPES[branch]  -- Each branch has a primary stat
            local percentage = getRandomMultiplier()
            local stat_string = getStatString(mult_type, percentage)
            
            TreeLogic.TreeStats[node_id] = {
                x = math.floor(x),
                y = math.floor(y),
                stats = {
                    stat_string,
                    mult_type,
                    percentage
                },
                links = { prev_node }
            }
            
            -- Link previous node to this node (bidirectional)
            if not TreeLogic.TreeStats[prev_node].links then
                TreeLogic.TreeStats[prev_node].links = {}
            end
            if prev_node ~= 1 or depth == 1 then
                table.insert(TreeLogic.TreeStats[prev_node].links, node_id)
            end
            
            -- Occasionally add cross-connections for variety
            if depth > 3 and math.random(1, 4) == 1 and node_id > 20 then
                local other_node = math.random(math.max(1, node_id - 25), node_id - 2)
                if other_node ~= prev_node then
                    table.insert(TreeLogic.TreeStats[node_id].links, other_node)
                    if not TreeLogic.TreeStats[other_node].links then
                        TreeLogic.TreeStats[other_node].links = {}
                    end
                    table.insert(TreeLogic.TreeStats[other_node].links, node_id)
                end
            end
            
            prev_node = node_id
            node_id = node_id + 1
            
            if node_id > 200 then break end
        end
        
        if node_id > 200 then break end
    end
    
    -- Ensure we have exactly the nodes we need by trimming or adjusting
    while node_id <= 200 do
        local angle = math.random() * 2 * math.pi
        local distance = math.random(100, 500)
        local x = math.cos(angle) * distance
        local y = math.sin(angle) * distance
        
        local mult_type = getRandomMultiplierType()
        local percentage = getRandomMultiplier()
        local stat_string = getStatString(mult_type, percentage)
        
        TreeLogic.TreeStats[node_id] = {
            x = math.floor(x),
            y = math.floor(y),
            stats = {
                stat_string,
                mult_type,
                percentage
            },
            links = { math.random(1, math.max(1, node_id - 1)) }
        }
        
        node_id = node_id + 1
    end
end

-- Helper function to print tree structure (debug)
local function printTreeStats()
    for i = 1, 200 do
        if TreeLogic.TreeStats[i] then
            print(string.format("Node %d: (%d, %d) | %s | Links: %s",
                i,
                TreeLogic.TreeStats[i].x,
                TreeLogic.TreeStats[i].y,
                TreeLogic.TreeStats[i].stats[1] or "ROOT",
                table.concat(TreeLogic.TreeStats[i].links, ", ")
            ))
        end
    end
end

-- Generate the tree on initialization
generateSkillTree()

TreeLogic.BoughtNodeIndexes = {}

return TreeLogic