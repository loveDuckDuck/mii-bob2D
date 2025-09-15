Wall = GameObject:extend()

function Wall:new(area, x, y, opts)
    Wall.super.new(self, area, x, y, opts)
    self.name = "Wall"
    
    self.w = 2000 
    self.h = 20 
    self.color = opts.color or { 0.4, 0.4, 0.5 }
    self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.w, self.h)
    self.collider:setPosition(self.x, self.y)
    self.collider:setObject(self)
    self.collider:setCollisionClass("Enemy")
    self.collider:setType("static")
end
function Wall:update(dt)
    Wall.super.update(self, dt)
end
function Wall:draw()
    love.graphics.setColor(self.color)
    PushRotate(self.flip and 0 or math.pi, self.x, self.y)
    love.graphics.rectangle("fill", self.x - self.w / 2, self.y - self.h / 2, self.w, self.h)
    love.graphics.pop()
    love.graphics.setColor(G_default_color)
end
function Wall:destroy()
    Wall.super.destroy(self)
end