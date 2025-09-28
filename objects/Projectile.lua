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
	self.invisible = false
	self.damage = opts.damage or Attacks[self.attack].damage or 1

	self.form = opts.form or Attacks[self.attack].resource
	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.radiusSpace)
	self.collider:setObject(self)
	self.collider:setLinearVelocity(self.velocity * math.cos(self.rotation), self.velocity * math.sin(self.rotation))
	self.collider:setCollisionClass("Projectile")

	-- CHECK THE MODS
	if self.projectile_ninety_degree_change then
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
	if self.wavy_projectiles then
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

	if self.fast_slow then
		local initial_v = self.velocity
		self.timer:tween("fast_slow_first", 0.2, self, { velocity = 2 * initial_v }, "in-out-cubic", function()
			self.timer:tween("fast_slow_second", 0.3, self, { velocity = initial_v / 2 }, "linear")
		end)
	end

	if self.slow_fast then
		local initial_v = self.v
		self.timer:tween("slow_fast_first", 0.2, self, { velocity = initial_v / 2 }, "in-out-cubic", function()
			self.timer:tween("slow_fast_second", 0.3, self, { velocity = 2 * initial_v }, "linear")
		end)
	end


	if self.shield then
		self.orbit_distance = GlobalRandom(32, 64)
		self.orbit_speed = GlobalRandom(-6, 6)
		self.orbit_offset = GlobalRandom(0, 2 * math.pi)
		self.time = 1
	end


	-- CHECK THE ATTACKS
	if self.attack == "Spin" then
		self.rv = table.random({ GlobalRandom(-2 * math.pi, -math.pi), GlobalRandom(math.pi, 2 * math.pi) })
		self.timer:after(GlobalRandom(2.4, 3.2), function()
			self:die()
		end)
		self.timer:every(0.05, function()
			self.area:addGameObject('ProjectileTrail', self.x, self.y,
				{
					rotation = Vector(self.collider:getLinearVelocity()):angle(),
					color = self.color,
					radiusSpace = self.radiusSpace
				})
		end)
	end


	if self.attack == "Flame" then
		self.timer:after(GlobalRandom(0.6, 0.8), function()
			self:die()
		end)
		self.timer:every(0.05, function()
			self.area:addGameObject('ProjectileTrail', self.x, self.y,
				{
					rotation = Vector(self.collider:getLinearVelocity()):angle(),
					color = self.color,
					radiusSpace = self.radiusSpace
				})
		end)
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
	-- Homing or Destroyer
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
	elseif self.attack == 'Blast' then
		self.damage = 75
		self.color = table.random(G_negative_colors)
		if not self.shield then
			self.timer:tween(GlobalRandom(0.4, 0.6), self, { velocity = 0 }, 'linear', function() self:die() end)
		end
	elseif self.attack == "Spin" then
		self.rotation = self.rotation + self.rv * dt
		-- HERE I AM CHECK IF A AM SHIELD
	elseif self.attack == "Bounce" then
		if self.bounce and self.bounce > 1 then
			local randomOffset = math.rad(GlobalRandom(-15, 15)) -- random ±15° offset
			if self.x < 0 then
				self.rotation = math.pi - self.rotation + randomOffset
				self.bounce = self.bounce - 1
			end
			if self.y < 0 then
				self.rotation = 2 * math.pi - self.rotation + randomOffset
				self.bounce = self.bounce - 1
			end
			if self.x > gw then
				self.rotation = math.pi - self.rotation + randomOffset
				self.bounce = self.bounce - 1
			end
			if self.y > gh then
				self.rotation = 2 * math.pi - self.rotation + randomOffset
				self.bounce = self.bounce - 1
			end
		else
			if self.x < 0 or self.x > gw or self.y < 0 or self.y > gh then
				self:die()
			end
		end
	elseif self.attack == "2Split" or self.attack == "4Split" then
		if self.bounce and self.bounce > 1 then
			local randomOffset = math.rad(GlobalRandom(-15, 15)) -- random ±15° offset
			local isSplit = false
			if self.x < 0 then
				self.rotation = math.pi - self.rotation + randomOffset
				self.bounce = self.bounce - 1
				isSplit = true
			end
			if self.y < 0 then
				self.rotation = 2 * math.pi - self.rotation + randomOffset
				self.bounce = self.bounce - 1
				isSplit = true
			end
			if self.x > gw then
				self.rotation = math.pi - self.rotation + randomOffset
				self.bounce = self.bounce - 1
				isSplit = true
			end
			if self.y > gh then
				self.rotation = 2 * math.pi - self.rotation + randomOffset
				self.bounce = self.bounce - 1
				isSplit = true
			end

			if isSplit then
				local baseRotation = self.rotation
				local rotation1 = baseRotation + math.pi / 2 -- +90°
				local rotation2 = baseRotation - math.pi / 2 -- -90°
				local rotation3 = baseRotation - math.pi / 4 -- -90°
				local rotation4 = baseRotation + math.pi / 4 -- -90°

				if self.attack == "4Split" then
					self.parent.area:addGameObject(
						"Projectile",
						self.x + math.cos(rotation3),
						self.y + math.sin(rotation3),
						{
							bounce = self.bounce,
							parent = self.parent,
							velocity = self.velocity,
							damage = self.damage,
							distance = self.distance,
							form = self.formTear,
							attack = self.attack,
							rotation = rotation3
						})
					self.parent.area:addGameObject(
						"Projectile",
						self.x + math.cos(rotation4),
						self.y + math.sin(rotation4),
						{
							bounce = self.bounce,
							parent = self.parent,
							velocity = self.velocity,
							damage = self.damage,
							distance = self.distance,
							form = self.formTear,
							attack = self.attack,
							rotation = rotation4
						})
				end



				self.parent.area:addGameObject(
					"Projectile",
					self.x + math.cos(rotation1),
					self.y + math.sin(rotation1),
					{
						bounce = self.bounce,
						parent = self.parent,
						velocity = self.velocity,
						damage = self.damage,
						distance = self.distance,
						form = self.formTear,
						attack = self.attack,
						rotation = rotation1
					})
				self.parent.area:addGameObject(
					"Projectile",
					self.x + math.cos(rotation2),
					self.y + math.sin(rotation2),
					{
						bounce = self.bounce,
						parent = self.parent,
						velocity = self.velocity,
						damage = self.damage,
						distance = self.distance,
						form = self.formTear,
						attack = self.attack,
						rotation = rotation2
					})
			end
		else
			if self.x < 0 or self.x > gw or self.y < 0 or self.y > gh then
				self:die()
			end
		end
	elseif self.attack == "Explode" then
		if self.x < 0 or self.x > gw or self.y < 0 or self.y > gh then
			self:die()

			self.parent.area:addGameObject("Explosion", self.x, self.y, {
				color = self.color,
				rotation = self.parent.rotation
			})
		end


		-- CHECK MODS IN UPDATE
	elseif self.shield then
		self.time = self.time + dt
		self.collider:setPosition(
			self.parent.x + self.orbit_distance * math.cos(self.orbit_speed * self.time + self.orbit_offset),
			self.parent.y + self.orbit_distance * math.sin(self.orbit_speed * self.time + self.orbit_offset)
		)
		self.invisible = true
		if self.attack == "Blast" then
			self.timer:after(6, function() self:die() end)
		else
			self.timer:after(0.05, function()
				self.invisible = false
			end)
		end
		self.timer:after(4, function() self:die() end)
	end

	if self.attack ~= "Homing" and self.attack ~= "Destroyer" then
		self.collider:setLinearVelocity(
			self.velocity * math.cos(self.rotation),
			self.velocity * math.sin(self.rotation)
		)
	end
	if self.attack ~= "Bounce" and self.attack ~= "2Split" then
		if self.x < 0 or self.x > gw or self.y < 0 or self.y > gh then
			self:die()
		end
	end
end

function Projectile:draw()
	if self.invisible then
		return
	end
	if self.attack == 'Bounce' then
		love.graphics.setColor(table.random(G_default_colors))
	else
		love.graphics.setColor(self.color)
	end
	-- PushRotate(self.x, self.y, self.collider:getAngle())
	if self.form then
		self.form(self.x, self.y, self.radiusSpace, self.radiusSpace)
	else
		self.form = Attacks["Neutral"].resource
		self.form(self.x, self.y, self.radiusSpace, self.radiusSpace)
	end
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
