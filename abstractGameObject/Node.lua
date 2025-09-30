Node = Object:extend()

function Node:new(id, x, y)
    self.id = id
    self.x, self.y = x, y
    self.r = 12
    self.bought = false
    self.w, self.h = self.r, self.r
    self.color = {}
    for index, value in ipairs(G_default_color) do
        self.color[index] = value
    end
end

function Node:update(dt)
    local mx, my = GCamera:getMousePosition(sx * GCamera.scale, sy * GCamera.scale, 0, 0, sx * gw, sy * gh)
    if mx >= self.x - self.w / 2 and mx <= self.x + self.w / 2 and
        my >= self.y - self.h / 2 and my <= self.y + self.h / 2 then
        self.hot = true
    else
        self.hot = false
    end

    if not self.bought then
        for _, value in ipairs(TreeLogic.BoughtNodeIndexes) do
            if (value == self.id) then
                print(self.id,"bought")
                self.bought = true
            end
        end
    end
end

function Node:draw()
    love.graphics.setColor(G_background_color)
    love.graphics.circle('fill', self.x, self.y, self.r)
    if self.bought then
        love.graphics.setColor(self.color[1], self.color[2], self.color[3], 1)
    else
        love.graphics.setColor(self.color[1], self.color[2], self.color[3], 0.5)
    end
    love.graphics.circle('fill', self.x, self.y, self.r)
end
