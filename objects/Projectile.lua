Projectile = GameObject:extend()

function Projectile:new(area, x, y, opts)
	Projectile.super.new(self, area, x, y, opts)
	-- s rappresente the radius of the collider and the surroi
	self.radiusSpace = opts.s or 2.5
	self.velocity = opts.velocity or G_default_player_velocity

	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.radiusSpace)
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
	--[[
        XXX: PROBLEM with distance projectile
    ]]

	local vx, vy = self.collider:getLinearVelocity()

	local top_bound = self.parent.y - gh / 2
	local bottom_bound = self.parent.y + gh / 2
	local left_bound = self.parent.x - gw / 2
	local right_bound = self.parent.x + gw / 2

	if self.x < left_bound or self.x > right_bound then
		if not self.bounce then
			self:die()
		else
			-- Reverse the horizontal velocity for a bounce
			self.collider:setLinearVelocity(-vx, vy)
		end
	end

	if self.y < top_bound or self.y > bottom_bound then
		if not self.bounce then
			self:die()
		else
			-- Reverse the vertical velocity for a bounce
			self.collider:setLinearVelocity(vx, -vy)
		end
	end
end

function Projectile:draw()
	love.graphics.setColor(G_hp_color)

	PushRotate(self.x, self.y, self.collider:getAngle())
	love.graphics.circle("line", self.x, self.y, self.radiusSpace)

	love.graphics.pop()
end

function Projectile:die()
	self.dead = true
	self.area:addGameObject("ProjectileDeathEffect", self.x, self.y, { color = G_hp_color, w = 3 * self.radiusSpace })
end
