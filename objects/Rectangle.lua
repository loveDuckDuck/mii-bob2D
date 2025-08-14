local Shape = require 'objects/Shape'

local Rectangle = Shape:extend()

function Rectangle:new(height, width, x, y, color)
    Rectangle.super.new(self, height, width, x, y, color)
    print("color param:", self.color[1],self.color[2],self.color[3])
end

function Rectangle:update(dt)
    Rectangle.super.update(self, dt)
end

function Rectangle:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1)
end

return Rectangle
