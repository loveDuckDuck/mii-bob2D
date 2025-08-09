Object = require 'libraries/classic/classic'

HyperCircle = Circle:extend()

function HyperCircle:new(x, y, radius, line_width, outer_radius)
    HyperCircle.super.new(self, x, y, radius)
    self.line_width = line_width
    self.outer_radius = outer_radius
end

function HyperCircle:update(dt)
    HyperCircle.super.update(self, dt)
end

function HyperCircle:draw()
    HyperCircle.super.draw(self)
    love.graphics.setLineWidth(self.line_width)
    love.graphics.circle('line', self.x, self.y, self.outer_radius)
    love.graphics.setLineWidth(1)
end

function HyperCircle:move(direction_x, direction_y)
    self.x = self.x + direction_x
    self.y = self.y + direction_y
end
