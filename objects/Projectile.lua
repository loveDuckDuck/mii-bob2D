Projectile = GameObject:extend()

function Projectile:new(area, x, y, opts)
	Projectile.super.new(self, area, x, y, opts)
	-- s rappresente the radius of the collider and the surroi
	self.radiusSpace = opts.s or 2.5
	self.attack = opts.attack or "Neutral"
	self.acceleration = 0
	self.velocity = opts.velocity or 300
	self.rotation = opts.rotation or 0
	self.color = opts.color or G_default_color
	self.parent = opts.parent or nil

	self.bounce = false or self.isBounce
	self.damage = opts.damage or Attacks[self.attack].damage or 1

	self.form = opts.form or Attacks[self.attack].resource
	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.radiusSpace)
	self.collider:setObject(self)
	self.collider:setLinearVelocity(self.velocity * math.cos(self.rotation), self.velocity * math.sin(self.rotation))
	self.collider:setCollisionClass("Projectile")

	-- increase in a linear way my velocity
	--self.timer:tween(0.5, self, { velocity = 400 }, 'linear')
end

--- Checks for collision between the projectile and an enemy.
-- If a collision is detected, adds an "ExplodeParticle" game object at the projectile's position.
-- The particle inherits the projectile's color and has a width based on the projectile's radius.

function Projectile:checkCollision()
	if self.collider:enter("Enemy") then
		local collision_data = self.collider:getEnterCollisionData("Enemy")
		local object = collision_data.collider:getObject()
		if object then
			object:hit(self.damage)
			self:explode()
			if object.hp <= 0 then
				GlobalRoomController.current_room.player:onKill()
			end
		end
	end
end

function Projectile:update(dt)
	Projectile.super.update(self, dt)
	self:checkCollision()

	-- Homing
	if self.attack == "Homing" or self.attack == "Destroyer" then
		-- Acquire new target
		if not self.target then
			local targets = self.area:getAllGameObjectsThat(function(e)
				for _, enemy in ipairs(Enemies) do
					if e:is(_G[enemy]) and (GlobalDistance(e.x, e.y, self.x, self.y) < 400) then
						return true
					end
				end
			end)

			self.target = table.remove(targets, love.math.random(1, #targets))
		end
		if self.target and self.target.dead then
			self.target = nil
		end
		-- Move towards target
		if self.target then
			local projectile_heading = Vector(self.collider:getLinearVelocity()):normalized()
			local angle = GlobalAtan2(self.target.y - self.y, self.target.x - self.x)
			local to_target_heading = Vector(math.cos(angle), math.sin(angle)):normalized()
			local final_heading = (projectile_heading + to_target_heading):normalized()
			self.collider:setLinearVelocity(self.velocity * final_heading.x, self.velocity * final_heading.y)
		end
	else
		self.collider:setLinearVelocity(
			self.velocity * math.cos(self.rotation),
			self.velocity * math.sin(self.rotation)
		)
	end

	--[[
        XXX: PROBLEM with distance projectile
    ]]

	-- local top_bound = self.parent.y - gh / 2
	-- local bottom_bound = self.parent.y + gh / 2
	-- local left_bound = self.parent.x - gw / 2
	-- local right_bound = self.parent.x + gw / 2
	-- -- NORMAL MOVEMENT WITHOUT BOUNCE
	-- if self.x < left_bound or self.x > right_bound then
	-- 	if not self.bounce then
	-- 		self:die()
	-- 	else
	-- 		-- Reverse the horizontal velocity for a bounce
	-- 		self.collider:setLinearVelocity(-vx, vy)
	-- 	end
	-- end

	-- if self.y < top_bound or self.y > bottom_bound then
	-- 	if not self.bounce then
	-- 		self:die()
	-- 	else
	-- 		-- Reverse the vertical velocity for a bounce
	-- 		self.collider:setLinearVelocity(vx, -vy)
	-- 	end
	-- end
end

function Projectile:draw()
	love.graphics.setColor(self.color)

	PushRotate(self.x, self.y, self.collider:getAngle())

	self.form(self.x, self.y, self.radiusSpace, self.radiusSpace)

	-- if self.form then
	-- 	for _, value in pairs(self.form) do
	-- 		value(self.x, self.y, self.radiusSpace, self.radiusSpace)
	-- 	end
	-- else
	-- 	love.graphics.circle("fill", self.x, self.y, self.radiusSpace)
	-- end

	love.graphics.pop()
	love.graphics.setColor(G_default_color)
end

function Projectile:die()
	self.dead = true
	self.area:addGameObject("ProjectileDeathEffect", self.x, self.y, { color = self.color, w = 3 * self.radiusSpace })
end

function Projectile:explode()
	self.dead = true
	self.area:addGameObject("ExplodeParticle", self.x, self.y, { color = self.color, w = 3 * self.radiusSpace })
end
