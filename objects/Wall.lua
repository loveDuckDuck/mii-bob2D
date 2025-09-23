Wall = GameObject:extend()

function Wall:new(area, x, y, opts)
    Wall.super.new(self, area, x, y, opts)
    -- PHYSICS
    self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.width, self.height)
    self.collider:setObject(self)
    self.collider:setCollisionClass("Wall")
    self.collider:setType("static")
end

function Wall:update(dt)
    Wall.super.new(self, dt)
end

function Wall:draw()

end
