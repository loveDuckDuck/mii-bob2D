local TreeLogic = {
    TreeStats = {},
    BoughtNodeIndexes = {}
}


TreeLogic.TreeStats[1] = { x = 0, y = 0, stats = {}, links = { 2 } }
TreeLogic.TreeStats[2] = { x = 48, y = 0, stats = { '4% Increased HP', 'hp_multiplier', 0.04 }, links = { 1, 3 } }
TreeLogic.TreeStats[3] = { x = 96, y = 0, stats = { '6% Increased HP', 'hp_multiplier', 0.06 }, links = { 2, 4 } }
TreeLogic.TreeStats[4] = { x = 144, y = 0, stats = { '4% Increased HP', 'hp_multiplier', 0.04 }, links = { 3 } }

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

TreeLogic.BoughtNodeIndexes = {}

local MAX_POINTS = 1000

--[[
    XXX : NOW I DONT NEED IT
]]
function CreateSkillTree(path)
    local imageData = love.image.newImageData(path)
    local width, height = imageData:getWidth(), imageData:getHeight()

    -- Convert to grayscale
    local gray = {}
    for y = 0, height - 1 do
        gray[y] = {}
        for x = 0, width - 1 do
            local r, g, b, a = imageData:getPixel(x, y)
            local lum = 0.3 * r + 0.59 * g + 0.11 * b
            gray[y][x] = lum
        end
    end

    -- Sobel kernels
    local gx = { { -1, 0, 1 }, { -2, 0, 2 }, { -1, 0, 1 } }
    local gy = { { -1, -2, -1 }, { 0, 0, 0 }, { 1, 2, 1 } }

    local candidates = {}

    -- Apply Sobel
    for y = 2, height - 2 do
        for x = 2, width - 2 do
            local SX, SY = 0, 0
            for ky = -1, 1 do
                for kx = -1, 1 do
                    local px = gray[y + ky][x + kx]
                    SX = SX + gx[ky + 2][kx + 2] * px
                    SY = SY + gy[ky + 2][kx + 2] * px
                end
            end
            local mag = math.sqrt(SX * SX + SY * SY)
            if mag > 0.25 then
                -- Map (x,y) into [-500,500]
                local mappedX = (x / width) * 1000 - 500
                local mappedY = (y / height) * 1000 - 500

                -- inside it i got all the points thank to the sobel kernels
                table.insert(candidates, { x = mappedX, y = mappedY })
            end
        end
    end

    -- Downsample: pick random subset
    math.randomseed(os.time())
    for i = 1, math.min(MAX_POINTS, #candidates) do
        local idx = math.random(#candidates)

        table.insert(TreeLogic.TreeStats,
            { x = candidates[idx].x, y = candidates[idx].y, stats = { "4% Increased HP" }, links = {} })
        table.remove(candidates, idx)
        for i = idx, idx + 100, 1 do
            if candidates[i] then
                table.remove(candidates, i)
            end
        end
    end
end

return TreeLogic
