Rock = GameObject:extend()

function Rock:new(area, x, y, opts)
    Rock.super.new(self, area, x, y, opts)

    local direction = table.random({-1, 1})
    self.x = gw/2 + direction*(gw/2 + 48)
    self.y = GlobalRandom(16, gh - 16)

    self.w, self.h = 8, 8
    self.collider = self.area.world:newPolygonCollider(CreateIrregularPolygon(8))
    self.collider:setPosition(self.x, self.y)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Enemy')
    self.collider:setFixedRotation(false)
    self.velocity= -direction*GlobalRandom(20, 40)
    self.collider:setLinearVelocity(self.velocity, 0)
    self.collider:applyAngularImpulse(GlobalRandom(-100, 100))
end

function Rock:update(dt)
    Rock.super.update(self,dt)
    
end

function Rock:draw()
    love.graphics.setColor(hp_color)
    local points = {self.collider:getWorldPoints(self.collider.shapes.main:getPoints())}
    love.graphics.polygon('line', points)
    love.graphics.setColor(default_color)
end