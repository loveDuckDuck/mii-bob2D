RectangleGameObject = GameObject:extend()
function RectangleGameObject:new(area, x, y, opts)
    RectangleGameObject.super.new(self, area, x, y, opts)
    self.x, self.y = x, y
    self.width , self.height = opts.width,opts.height
    self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.width,self.height)
    self.collider:setObject(self)

end

function RectangleGameObject:update(dt)
    RectangleGameObject.super.update(self, dt)
end

function RectangleGameObject:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width,self.height)

end
