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

    self.timer:every(0.24, function()
        self:shoot()
    end)
end

function Player:shoot()
    local distance = 1.2 * self.w
    self.area:addGameObject('ShootEffect', self.x + distance * math.cos(self.rotation),
        self.y + distance * math.sin(self.rotation), { player = self, distance = distance })
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


    --[[ love2D reference

                        up 270 / -90
                       |
                       |
                       |
                       |
                       |
   right 0---------------------------180 left
                       |
                       |
                       |
                       |
                       |
                        down 90
    ]]



    -- Check diagonal movements first (they require two keys)
    if love.keyboard.isDown('up') and love.keyboard.isDown('right') then
        self.rotation = -math.pi / 4     -- 45 degrees up-right
    elseif love.keyboard.isDown('up') and love.keyboard.isDown('left') then
        self.rotation = -3 * math.pi / 4 -- 135 degrees up-left
    elseif love.keyboard.isDown('down') and love.keyboard.isDown('right') then
        self.rotation = math.pi / 4      -- 45 degrees down-right
    elseif love.keyboard.isDown('down') and love.keyboard.isDown('left') then
        self.rotation = 3 * math.pi / 4  -- 135 degrees down-left
        -- Then check single key movements
    elseif love.keyboard.isDown('right') then
        self.rotation = 0            -- 0 degrees (facing right)
    elseif love.keyboard.isDown("left") then
        self.rotation = math.pi      -- 180 degrees (facing left)
    elseif love.keyboard.isDown("down") then
        self.rotation = math.pi / 2  -- 90 degrees (facing down)
    elseif love.keyboard.isDown("up") then
        self.rotation = -math.pi / 2 -- -90 degrees (facing up)
    else
        -- Default rotation when no keys are pressed
        self.rotation = math.pi / 2 -- Or whatever default you want
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
