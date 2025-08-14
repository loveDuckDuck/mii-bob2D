local Object = require 'libraries/classic/classic'
local Shape = Object:extend()

function Shape:new(height, width, x, y, color)
    self.height, self.width = height, width
    self.x, self.y = x, y
    self.creation_time = love.timer.getTime()
    self.color = color or { 1, 1, 1 }
end

function Shape:update(dt)
end

function Shape:draw()
end

return Shape
