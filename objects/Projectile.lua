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
	self.projectileManager = opts.projectileManager or nil

	self.bounce = false or self.isBounce
	self.damage = opts.damage or Attacks[self.attack].damage or 1

	self.form = opts.form or Attacks[self.attack].resource
	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.radiusSpace)
	self.collider:setObject(self)
	self.collider:setLinearVelocity(self.velocity * math.cos(self.rotation), self.velocity * math.sin(self.rotation))
	self.collider:setCollisionClass("Projectile")
	if self.projectileManager then
		if self.projectileManager.projectile_ninety_degree_change then
			self.timer:after(0.2, function()
				self.ninety_degree_direction = table.random({ -1, 1 })
				self.rotation = self.rotation + self.ninety_degree_direction * math.pi / 2
				self.timer:every("ninety_degree_first", 0.25, function()
					self.rotation = self.rotation - self.ninety_degree_direction * math.pi / 2
					self.timer:after("ninety_degree_second", 0.1, function()
						self.rotation = self.rotation - self.ninety_degree_direction * math.pi / 2
						self.ninety_degree_direction = -1 * self.ninety_degree_direction
					end)
				end)
			end)
		end
		if self.projectileManager.wavy_projectiles then
			local direction = table.random({ -1, 1 })
			self.timer:tween(0.25, self, { rotation = self.rotation + direction * math.pi / 8 }, "linear", function()
				self.timer:tween(0.25, self, { rotation = self.rotation - direction * math.pi / 4 }, "linear")
			end)
			self.timer:every(0.75, function()
				self.timer:tween(
					0.25,
					self,
					{ rotation = self.rotation + direction * math.pi / 4 },
					"linear",
					function()
						self.timer:tween(0.5, self, { rotation = self.rotation - direction * math.pi / 4 }, "linear")
					end
				)
			end)
		end

		if self.projectileManager.fast_slow then
			local initial_v = self.velocity
			self.timer:tween("fast_slow_first", 0.2, self, { velocity = 2 * initial_v }, "in-out-cubic", function()
				self.timer:tween("fast_slow_second", 0.3, self, { velocity = initial_v / 2 }, "linear")
			end)
		end

		if self.projectileManager.slow_fast then
			local initial_v = self.v
			self.timer:tween("slow_fast_first", 0.2, self, { velocity = initial_v / 2 }, "in-out-cubic", function()
				self.timer:tween("slow_fast_second", 0.3, self, { velocity = 2 * initial_v }, "linear")
			end)
		end
	end

	if self.shield then
		self.orbit_distance = GlobalRandom(32, 64)
		self.orbit_speed = GlobalRandom(-6, 6)
		self.orbit_offset = GlobalRandom(0, 2 * math.pi)
		self.time = 1
	end

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
				GlobalRoomController.current_room.player.chance:onKill()
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
	elseif self.shield then
		self.invisible = true
		
		self.timer:after(0.05, function()
			self.invisible = false
		end)

		self.time = self.time + dt
		self.collider:setPosition(
			self.parent.x + self.orbit_distance * math.cos(self.orbit_speed * self.time + self.orbit_offset),
			self.parent.y + self.orbit_distance * math.sin(self.orbit_speed * self.time + self.orbit_offset)
		)
	else
		self.collider:setLinearVelocity(
			self.velocity * math.cos(self.rotation),
			self.velocity * math.sin(self.rotation)
		)
	end

	if self.x < 0 or self.x > gw or self.y < 0 or self.y > gh then
		self:die()
	end
end

function Projectile:draw()
	if self.invisible then
		return
	end
	love.graphics.setColor(self.color)
	-- PushRotate(self.x, self.y, self.collider:getAngle())
	local px, py = self.collider:getPosition()
	self.form(px, py, self.radiusSpace, self.radiusSpace)

	-- love.graphics.pop()
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
