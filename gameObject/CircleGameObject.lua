GameObject = require'gameObject/GameObject'

CircleGameObject = GameObject:extend()

function CircleGameObject:new(area,x,y,opt)
    CircleGameObject.super.new(self,area,x,y,opt)
end

function CircleGameObject:update(dt)
    CircleGameObject.super.update(self,dt)
end

function  CircleGameObject:draw()
   -- love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, 100)
   -- love.graphics.setColor(1, 1, 1)
end
