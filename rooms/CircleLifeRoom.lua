Object = require 'libraries/classic/classic'
CircleLifeRoom = Object:extend()

function CircleLifeRoom:new()
    self.areas = Area() -- <----- area containers
    self.type = 'CircleLifeRoom'
    self.creation_time = love.timer.getTime()
    self.timer = Timer()
    self.timer:every(2, function()
        self.area:addGameObject('CircleGameObject', 
        love.math.random(0, love.graphics.getWidth()),
        love.math.random(0, love.graphics.getHeight()))
    end)
end

function CircleLifeRoom:update(dt)
    if (next(self.areas) ~= nil) then
        -- Iterating over an array-like table
        for _, area in ipairs(self.areas) do
            area:update(dt)
        end
    end
        self.timer:update(dt)
end

function CircleLifeRoom:draw()
    if (next(self.areas) ~= nil) then
        -- Iterating over an array-like table
        for _, area in ipairs(self.areas) do
            area:draw()
        end
    end
end

function CircleLifeRoom:addArea(area)
    table.insert(self.areas, area)
end
