Explosion = GameObject:extend()

--[[
    TODO : FINISH THE EXPLOSION
]]
function Explosion:new(area, x, y, opts)
    Explosion.super.new(self, area, x, y, opts)
    self.w = 1
    self.h = 1
    self.offestExplosion = opts.offestExplosion or 48
    self.velocity = opts.velocity or 300

    self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.w, self.h)
    self.collider:setObject(self)
    self.collider:setLinearVelocity(self.velocity * math.cos(self.rotation), self.velocity * math.sin(self.rotation))
    self.collider:setCollisionClass("Projectile")
    self.collider:setType("static")

    self.color = G_white_cream

    self.timer:tween(0.2, self, { h = self.offestExplosion, w = self.offestExplosion }, 'in-out-cubic',
        function()
            self.timer:tween(1, self, { h = 1, w = 1 }, 'in-out-cubic',
                function()
                    self.dead = true
                end)
        end
    )
    self.timer:after(0.05, function()
        self.color = G_hp_color
    end)
    self.timer:after(0.15, function()
        for i = 1, love.math.random(8, 20) do
            local rotation = math.randomAngle(math.pi / 2, -math.pi / 2)
            if self.x < 0 then
                print("x -- 0")
                rotation = math.randomAngle(-math.pi / 2, math.pi / 2)
            elseif self.x > gw then
                print("x -- gw")
                rotation = math.randomAngle(math.pi / 2, 3 * math.pi / 2)
            elseif self.y < 0 then
                print("y -- 0")
                rotation = math.randomAngle(0, math.pi)
            elseif self.y > gh then
                print("y -- gh")
                rotation = math.randomAngle(math.pi, 2 * math.pi)
            end

            self.area:addGameObject("ExplodeParticle", self.x, self.y,
                { s = 5, color = self.color, d = 0.7, v = 150, rotation = rotation })
        end
    end)
end

function Explosion:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x - self.w / 2, self.y - self.h / 2, self.w, self.h)
    love.graphics.setColor(255, 255, 255)
end

function Explosion:update(dt)
    Explosion.super.update(self, dt)
end

function Explosion:destroy()
    Explosion.super.destroy(self)
end
