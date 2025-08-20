Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)
    self.x, self.y = x, y
    self.w, self.h = 12, 12
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    self.collider:setObject(self)


    self.rotation = -math.pi / 2 -- look up
    self.rotationVelocity = 1.66 * math.pi
    self.velocity = 0
    self.maxVelocity = 100
    self.acceleration = 100
end

function Player:update(dt)
    Player.super.update(self, dt)

    if InputHandler:down('left') then self.rotation = self.rotation - self.rotationVelocity * dt end
    if InputHandler:down('right') then self.rotation = self.rotation + self.rotationVelocity * dt end

    self.velocity = math.min(self.velocity + self.acceleration * dt, self.maxVelocity)
    self.collider:setLinearVelocity(self.velocity * math.cos(self.rotation), self.velocity * math.sin(self.rotation))
    

end

function Player:draw()
    love.graphics.circle('line', self.x, self.y, 25)
    love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.rotation), self.y + 2*self.w*math.sin(self.rotation))
end
