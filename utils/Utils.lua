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
gw = window_width

gh = window_height

    print("Scale updated: sx =", sx, "sy =", sy)
    -- Optional: Use uniform scaling (same scale for both axes)
    -- local scale = math.min(sx, sy)
    -- sx, sy = scale, scale
end

function random(min, max)
    local min, max = min or 0, max or 1
    return (min > max and (love.math.random() * (min - max) + max)) or (love.math.random() * (max - min) + min)
end
