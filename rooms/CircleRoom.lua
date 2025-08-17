Object = require 'libraries/classic/classic'
local Circle = require 'objects/Circle'
-- in objects/Test.lua
CircleRoom = Object:extend()


function CircleRoom:new()
    self.circles = {} -- <--- initialize your circles table
    self.type = 'CircleRoom'
    self.creation_time = love.timer.getTime()
end

function CircleRoom:addCircle(x, y, radius)
    local circle = Circle(x, y, radius)
    table.insert(self.circles, circle)
end

function CircleRoom:update(dt)
    if (next(self.circles) ~= nil) then
        -- Iterating over an array-like table
        for i, fruit in ipairs(self.circles) do
            fruit:update(dt)
        end
    end
end

function CircleRoom:draw()
    if (next(self.circles) ~= nil) then
        -- Iterating over an array-like table
        for i, fruit in ipairs(self.circles) do
            fruit:draw()
        end
    end
end
