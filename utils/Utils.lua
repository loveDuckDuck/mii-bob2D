function UUID()
    local fn = function(x)
        local r = math.random(16) - 1
        r = (x == "x") and (r + 1) or (r % 4) + 9
        return ("0123456789abcdef"):sub(r, r)
    end
    return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end

function UpdateScale()
    local window_width = love.graphics.getWidth()
    local window_height = love.graphics.getHeight()

    -- Calculate scale to fit the game area in the window
    sx = gw / window_width  -- If window is 960px and gw=480px, sx = 0.5 (half size)
    sy = gh / window_height -- If window is 540px and gh=270px, sy = 0.5 (half size)

    gw = window_width * sx
    gh = window_height * sy

    print("Scale updated: sx =", sx, "sy =", sy)
    -- Optional: Use uniform scaling (same scale for both axes)
    -- local scale = math.min(sx, sy)
    -- sx, sy = scale, scale
end

function GlobalRandom(min, max)
    local min, max = min or 0, max or 1
    return (min > max and (love.math.random() * (min - max) + max)) or (love.math.random() * (max - min) + min)
end

function count_all(f)
    local seen = {}
    local count_table
    count_table = function(t)
        if seen[t] then return end
        f(t)
        seen[t] = true
        for k, v in pairs(t) do
            if type(v) == "table" then
                count_table(v)
            elseif type(v) == "userdata" then
                f(v)
            end
        end
    end
    count_table(_G)
end

function type_count()
    local counts = {}
    local enumerate = function(o)
        local t = type_name(o)
        counts[t] = (counts[t] or 0) + 1
    end
    count_all(enumerate)
    return counts
end

global_type_table = nil
function type_name(o)
    if global_type_table == nil then
        global_type_table = {}
        for k, v in pairs(_G) do
            global_type_table[v] = k
        end
        global_type_table[0] = "table"
    end
    return global_type_table[getmetatable(o) or 0] or "Unknown"
end

function DrawGarbageCollector()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print("Before collection: " .. collectgarbage("count") / 1024, 0, 0)
    collectgarbage()
    love.graphics.print("After collection: " .. collectgarbage("count") / 1024, 0, 20)

    -- Print the header for object counts
    love.graphics.print("Object count:", 0, 40)

    local counts = type_count()
    local y_offset = 60

    -- Loop through the counts and print each on a new line
    for k, v in pairs(counts) do
        love.graphics.print(k .. ": " .. v, 0, y_offset)
        y_offset = y_offset + 20 -- Increment the y-coordinate for the next line
    end
    
    love.graphics.print(gw .. " : " .. gh, 0,y_offset)
    y_offset = y_offset + 20
    
    love.graphics.setColor(1, 1, 1, 1)
    
end



function PushRotate(x, y, r)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r or 0)
    love.graphics.scale(sx or 1, sy or sx or 1)
    love.graphics.translate(-x, -y)
end

function PushRotateScale(x, y, r, sx, sy)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r or 0)
    love.graphics.scale(sx or 1, sy or sx or 1)
    love.graphics.translate(-x, -y)
end



function ShortestRotationPath(currentAngle, targetAngle)
    -- Normalize angles to [-π, π] range
    local function normalizeAngle(angle)
        while angle > math.pi do
            angle = angle - 2 * math.pi
        end
        while angle < -math.pi do
            angle = angle + 2 * math.pi
        end
        return angle
    end

    -- Calculate the difference
    local diff = normalizeAngle(targetAngle - currentAngle)

    return diff
end

function RotateTowards(player, targetAngle, dt)
    local rotationDiff = ShortestRotationPath(player.rotation, targetAngle)

    -- If we're close enough, snap to target
    if math.abs(rotationDiff) < 0.1 then
        player.rotation = targetAngle
    else
        -- Rotate towards target at rotationVelocity speed
        local rotationStep = player.rotationVelocity * dt
        if rotationDiff > 0 then
            player.rotation = player.rotation + math.min(rotationStep, rotationDiff)
        else
            player.rotation = player.rotation + math.max(-rotationStep, rotationDiff)
        end
    end
end

function Slow(amount, duration)
    GlobalSlowAmount = amount
    GlobalTimer:tween('Slow', duration, _G, {GlobalSlowAmount = 1}, 'in-out-cubic')
end


function DeleteEveryThing ()
    print("DeleteEveryThing")

    GlobalRoomController:printRoomNames()
end