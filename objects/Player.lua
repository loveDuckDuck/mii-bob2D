Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)
    self.x, self.y = x, y
    self.w, self.h = 12, 12
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    self.collider:setObject(self)


    self.rotation = math.pi / 2 -- look down
    self.rotationVelocity = 1.66 * math.pi
    self.xvel = 0
    self.yvel = 0
    self.velocity = 0
    self.maxVelocity = 100
    self.acceleration = 100

    self.speed = 500

    self.friction = 5
end

function Player:physics(dt)
    self.xvel = self.xvel * (1 - math.min(dt * self.friction, 1))
    self.yvel = self.yvel * (1 - math.min(dt * self.friction, 1))

    -- Clamp velocities to max velocity
    local speed = math.sqrt(self.xvel ^ 2 + self.yvel ^ 2)
    if speed > self.maxVelocity then
        self.xvel = (self.xvel / speed) * self.maxVelocity
        self.yvel = (self.yvel / speed) * self.maxVelocity
    end


    self.x = self.x + self.xvel * dt
    self.y = self.y + self.yvel * dt

    self.collider:setPosition(self.x, self.y)
end

function shortestRotationPath(currentAngle, targetAngle)
    -- Normalize angles to [-π, π] range
    local function normalizeAngle(angle)
        while angle > math.pi do
            angle = angle - 2 * math.pi
        end
        while angle < -math.pi do
            angle = angle + 2 * math.pi
        end
        return angle
    end
    
    -- Calculate the difference
    local diff = normalizeAngle(targetAngle - currentAngle)
    
    return diff
end

function Player:rotateTowards(targetAngle, dt)
    local rotationDiff = shortestRotationPath(self.rotation, targetAngle)
    
    -- If we're close enough, snap to target
    if math.abs(rotationDiff) < 0.1 then
        self.rotation = targetAngle
    else
        -- Rotate towards target at rotationVelocity speed
        local rotationStep = self.rotationVelocity * dt
        if rotationDiff > 0 then
            self.rotation = self.rotation + math.min(rotationStep, rotationDiff)
        else
            self.rotation = self.rotation + math.max(-rotationStep, rotationDiff)
        end
    end
end

function Player:move(dt)
    if InputHandler:down("d") and self.xvel < self.speed then
        self.xvel = self.xvel + self.speed * dt
    end
    if InputHandler:down("a") and self.xvel > -self.speed then
        self.xvel = self.xvel - self.speed * dt
    end
    if InputHandler:down("s") and self.yvel < self.speed then
        self.yvel = self.yvel + self.speed * dt
    end
    if InputHandler:down("w") and self.yvel > -self.speed then
        self.yvel = self.yvel - self.speed * dt
    end

    local targetRotation = self.rotation -- keep current if no input


    if InputHandler:down("right") then
        targetRotation = 0
    elseif InputHandler:down("left") then
        targetRotation = -math.pi
    elseif InputHandler:down("down") then
        targetRotation = math.pi / 2
    elseif InputHandler:down("up") then
        targetRotation = -math.pi / 2
    end
    if love.keyboard.isDown('up', 'right') then
        print("both press")
    end
    if targetRotation ~= self.rotation then
        self:rotateTowards(targetRotation, dt)
    end
end

function Player:update(dt)
    Player.super.update(self, dt)

    self:physics(dt)
    self:move(dt)
end

function Player:draw()
    love.graphics.circle('line', self.x, self.y, 25)
    love.graphics.line(self.x, self.y, self.x + 2 * self.w * math.cos(self.rotation),
        self.y + 2 * self.w * math.sin(self.rotation))
end
