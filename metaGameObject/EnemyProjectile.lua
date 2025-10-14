EnemyProjectile = GameObject:extend()

function EnemyProjectile:new(area, x, y, opts)
	EnemyProjectile.super.new(self, area, x, y, opts)
	-- s rappresente the radius of the collider and the surroi
	self.radiusSpace = opts.s or 2.5
	self.velocity = opts.velocity or G_default_player_velocity
	self.color = opts.color or GHPColor
	self.damage = opts.damage or 2
	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.radiusSpace)
	self.collider:setObject(self)
	self.collider:setLinearVelocity(self.velocity * math.cos(self.rotation), self.velocity * math.sin(self.rotation))
	self.collider:setCollisionClass("EnemyProjectile")
	self.timer:after(1, function() self:die() end)

end

function EnemyProjectile:checkCollision(dt)
	if self.collider:enter("Player") then
		local collision_data = self.collider:getEnterCollisionData("Player")
		local object = collision_data.collider:getObject()
		if object and not object.invincible then
			object:hit(self.damage)
		end
		self:die()
	end
	
end

function EnemyProjectile:update(dt)
	EnemyProjectile.super.update(self, dt)
	--[[
        XXX: PROBLEM with distance projectile
    ]]
	local top_bound = self.parent.y - GH / 2
	local bottom_bound = self.parent.y + GH / 2
	local left_bound = self.parent.x - GW / 2
	local right_bound = self.parent.x + GW / 2
	if self.x < left_bound or self.x > right_bound then
		self:die()
	end

	if self.y < top_bound or self.y > bottom_bound then
		self:die()
	end
	self:checkCollision(dt)
end

function EnemyProjectile:draw()
	love.graphics.setColor(self.color)
	PushRotate(self.x, self.y, self.collider:getAngle())
	love.graphics.circle("line", self.x, self.y, self.radiusSpace)
	love.graphics.pop()
	love.graphics.setColor(GDefaultColor)
end

function EnemyProjectile:die()
	self.dead = true
	self.area:addGameObject("ProjectileDeathEffect", self.x, self.y, { color = self.color, w = 3 * self.radiusSpace })
end
