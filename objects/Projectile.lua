Projectile = GameObject:extend()

function Projectile:new(area, x, y, opts)
	Projectile.super.new(self, area, x, y, opts)
	-- s rappresente the radius of the collider and the surroi
	self.radiusSpace = opts.s or 2.5
	
	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.radiusSpace)
	self.collider:setObject(self)
	self.collider:setLinearVelocity(self.velocity * math.cos(self.rotation), self.velocity * math.sin(self.rotation))
	self.collider:setCollisionClass("Projectile")
	self.acceleration = 0
	-- increase in a linear way my velocity
	--self.timer:tween(0.5, self, { velocity = 400 }, 'linear')
	self.bounce = false or self.isBounce
end
--- Checks for collision between the projectile and an enemy.
-- If a collision is detected, adds an "ExplodeParticle" game object at the projectile's position.
-- The particle inherits the projectile's color and has a width based on the projectile's radius.

function Projectile:checkCollision()
	-- if self.collider:enter("Enemy") then
	-- 	self.area:addGameObject("ExplodeParticle", self.x, self.y, { color = self.color, w = 3 * self.radiusSpace })
	-- end
end

function Projectile:update(dt)
	Projectile.super.update(self, dt)

	-- Homing
	if self.attack == "Homing" then
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
			local final_heading = (projectile_heading + 0.1 * to_target_heading):normalized()
			self.collider:setLinearVelocity(self.velocity * final_heading.x, self.velocity * final_heading.y)
		end
	end
	--[[
        XXX: PROBLEM with distance projectile
    ]]

	local vx, vy = self.collider:getLinearVelocity()

	self:checkCollision()

	local top_bound = self.parent.y - gh / 2
	local bottom_bound = self.parent.y + gh / 2
	local left_bound = self.parent.x - gw / 2
	local right_bound = self.parent.x + gw / 2
	-- NORMAL MOVEMENT WITHOUT BOUNCE
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
	love.graphics.setColor(self.color)

	PushRotate(self.x, self.y, self.collider:getAngle())
	love.graphics.circle("fill", self.x, self.y, self.radiusSpace)

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
