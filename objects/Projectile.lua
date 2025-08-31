Projectile = GameObject:extend()

function Projectile:new(area, x, y, opts)
	Projectile.super.new(self, area, x, y, opts)
	-- s rappresente the radius of the collider
	self.s = opts.s or 2.5
	self.velocity = opts.velocity or 200

	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.s)
	self.collider:setObject(self)
	self.collider:setLinearVelocity(self.velocity * math.cos(self.rotation), self.velocity * math.sin(self.rotation))
	    self.collider:setCollisionClass("Projectile")

	self.acceleration = 0
	-- increase in a linear way my velocity
	--self.timer:tween(0.5, self, { velocity = 400 }, 'linear')

	self.bounce = false or self.isBounce	
	if opts.attribute then
		self.attribute = opts.attribute
	else
		self.attribute = {}
	end
end

function Projectile:update(dt)
    Projectile.super.update(self, dt)
    local vx, vy = self.collider:getLinearVelocity()

    if self.x < 0 or self.x > gw then
        if not self.bounce then
            self:die()
        else
            -- Reverse the horizontal velocity for a bounce
            self.collider:setLinearVelocity(-vx, vy)
        end
    end

    if self.y < 0 or self.y > gh then
        if not self.bounce then
            self:die()
        else
            -- Reverse the vertical velocity for a bounce
            self.collider:setLinearVelocity(vx, -vy)
        end
    end
end

function Projectile:draw()
	love.graphics.setColor(G_default_color)
	love.graphics.circle("line", self.x, self.y, self.s)
end

function Projectile:die()
	self.dead = true
	self.area:addGameObject("ProjectileDeathEffect", self.x, self.y, { color = G_hp_color, w = 3 * self.s })
end
