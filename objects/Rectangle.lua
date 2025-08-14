local Object = require 'libraries/classic/classic'
local Shape = require 'objects/Shape'

Rectangle = Shape:extend()

function Rectangle:new(height, width, x, y, color)
    Rectangle.super.new(self, height, width, x, y, color)
end

function Rectangle:update(dt)
    Rectangle.super.update(self, dt)
end

function Rectangle:draw()
    Rectangle.super.draw(self)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
