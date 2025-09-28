Node = Object:extend()

function Node:new(x, y)
    self.x, self.y = x, y
end

function Node:update(dt)
    
end

function Node:draw()
    love.graphics.setColor(G_default_color)
    love.graphics.circle('line', self.x, self.y, 12)
end