-- main.lua
local imageData
local points = {}
local MAX_POINTS = 1000  -- <<<<< Change this to control number of points

function love.load()
    imageData = love.image.newImageData("input.png")
    local width, height = imageData:getWidth(), imageData:getHeight()

    -- Convert to grayscale
    local gray = {}
    for y = 0, height - 1 do
        gray[y] = {}
        for x = 0, width - 1 do
            local r, g, b, a = imageData:getPixel(x, y)
            local lum = 0.3*r + 0.59*g + 0.11*b
            gray[y][x] = lum
        end
    end

    -- Sobel kernels
    local gx = {{-1,0,1},{-2,0,2},{-1,0,1}}
    local gy = {{-1,-2,-1},{0,0,0},{1,2,1}}

    local candidates = {}

    -- Apply Sobel
    for y = 2, height - 2 do
        for x = 2, width - 2 do
            local SX, SY = 0, 0
            for ky = -1, 1 do
                for kx = -1, 1 do
                    local px = gray[y+ky][x+kx]
                    SX = SX + gx[ky+2][kx+2]*px
                    SY = SY + gy[ky+2][kx+2]*px
                end
            end
            local mag = math.sqrt(SX*SX + SY*SY)
            if mag > 0.25 then
                -- Map (x,y) into [-500,500]
                local mappedX = (x/width)*1000 - 500
                local mappedY = (y/height)*1000 - 500
                table.insert(candidates, {x=mappedX, y=mappedY})
            end
        end
    end

    -- Downsample: pick random subset
    math.randomseed(os.time())
    for i = 1, math.min(MAX_POINTS, #candidates) do
        local idx = math.random(#candidates)
        table.insert(points, candidates[idx])
        table.remove(candidates, idx)
    end
end

function love.draw()
    love.graphics.clear(0,0,0)
    love.graphics.setColor(1,1,1)

    for _,p in ipairs(points) do
        love.graphics.points(p.x+400, p.y+300)
    end

    love.graphics.print("Points: "..#points, 10, 10)
end
