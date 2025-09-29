Node = Object:extend()

function Node:new(id, x, y)
    self.id = id
    self.x, self.y = x, y
    self.r = 12
end

function Node:update(dt)
    function Node:update(dt)
        local mx, my = GCamera:getMousePosition(sx * GCamera.scale, sy * GCamera.scale, 0, 0, sx * gw, sy * gh)
        if mx >= self.x - self.w / 2 and mx <= self.x + self.w / 2 and
            my >= self.y - self.h / 2 and my <= self.y + self.h / 2 then
            self.hot = true
        else
            self.hot = false
        end
    end
end

function Node:draw()
    love.graphics.setColor(G_background_color)
    love.graphics.circle('fill', self.x, self.y, self.r)
    love.graphics.setColor(G_default_color)
    love.graphics.circle('line', self.x, self.y, self.r)
end
