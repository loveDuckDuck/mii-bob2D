Projectile = GameObject:extend()

-- Constants
local HOMING_RANGE = 400
local TRAIL_INTERVAL = 0.05
local TWO_PI = 2 * math.pi
local HALF_PI = math.pi / 2
local QUARTER_PI = math.pi / 4

function Projectile:new(area, x, y, opts)
	Projectile.super.new(self, area, x, y, opts)
	self.t = 0
	self.speed = opts.speed or 1
	self.scale = opts.scale or 5
	-- Core properties
	self.radiusSpace = opts.s or 2.5
	self.attack = opts.attack or "Neutral"
	self.velocity = opts.velocity or 300
	self.rotation = opts.rotation or 0
	self.color = opts.color or G_default_color
	self.parent = opts.parent
	self.invisible = false

	-- Damage calculation
	local attackData = Attacks[self.attack]
	self.damage = opts.damage or (attackData and attackData.damage) or 1
	self.form = opts.form or (attackData and attackData.resource)

	-- Physics setup
	self.collider = area.world:newCircleCollider(x, y, self.radiusSpace)
	self.collider:setObject(self)
	self.collider:setLinearVelocity(
		self.velocity * math.cos(self.rotation),
		self.velocity * math.sin(self.rotation)
	)
	self.collider:setCollisionClass("Projectile")

	-- Initialize modifiers
	self:initializeModifiers(opts)
	self:initializeAttackBehavior()
end

function Projectile:initializeModifiers(opts)
	-- Ninety degree change modifier
	if self.projectile_ninety_degree_change then
		self.timer:after(0.2, function()
			local direction = table.random({ -1, 1 })
			self.rotation = self.rotation + direction * HALF_PI
			self.ninety_degree_direction = direction

			self.timer:every("ninety_degree_first", 0.25, function()
				self.rotation = self.rotation - self.ninety_degree_direction * HALF_PI
				self.timer:after("ninety_degree_second", 0.1, function()
					self.rotation = self.rotation - self.ninety_degree_direction * HALF_PI
					self.ninety_degree_direction = -self.ninety_degree_direction
				end)
			end)
		end)
	end

	-- Wavy projectiles modifier
	if self.wavy_projectiles then
		local direction = table.random({ -1, 1 })
		local eighth_pi = math.pi / 8

		self.timer:tween(0.25, self, { rotation = self.rotation + direction * eighth_pi }, "linear", function()
			self.timer:tween(0.25, self, { rotation = self.rotation - direction * QUARTER_PI }, "linear")
		end)

		self.timer:every(0.75, function()
			self.timer:tween(0.25, self, { rotation = self.rotation + direction * QUARTER_PI }, "linear", function()
				self.timer:tween(0.5, self, { rotation = self.rotation - direction * QUARTER_PI }, "linear")
			end)
		end)
	end

	-- Speed modifiers
	if self.fast_slow then
		local initial_v = self.velocity
		self.timer:tween("fast_slow_first", 0.2, self, { velocity = 2 * initial_v }, "in-out-cubic", function()
			self.timer:tween("fast_slow_second", 0.3, self, { velocity = initial_v / 2 }, "linear")
		end)
	end

	if self.slow_fast then
		local initial_v = self.velocity
		self.timer:tween("slow_fast_first", 0.2, self, { velocity = initial_v / 2 }, "in-out-cubic", function()
			self.timer:tween("slow_fast_second", 0.3, self, { velocity = 2 * initial_v }, "linear")
		end)
	end

	-- Shield modifier
	if self.shield then
		self.orbit_distance = math.customRandom(32, 64)
		self.orbit_speed = math.customRandom(-6, 6)
		self.orbit_offset = math.customRandom(0, TWO_PI)
		self.time = 1
	end
end

function Projectile:initializeAttackBehavior()
	if self.attack == "Spin" then
		self.rv = table.random({
			math.customRandom(-TWO_PI, -math.pi),
			math.customRandom(math.pi, TWO_PI)
		})
		self.timer:after(math.customRandom(2.4, 3.2), function() self:die() end)
		self:startTrailEffect()
	elseif self.attack == "Flame" then
		self.timer:after(math.customRandom(0.6, 0.8), function() self:die() end)
		self:startTrailEffect()
	end
end

function Projectile:startTrailEffect()
	self.timer:every(TRAIL_INTERVAL, function()
		self.area:addGameObject('ProjectileTrail', self.x, self.y, {
			rotation = Vector(self.collider:getLinearVelocity()):angle(),
			color = self.color,
			radiusSpace = self.radiusSpace
		})
	end)
end

function Projectile:checkCollision()
	if self.collider:enter("Enemy") then
		local collision_data = self.collider:getEnterCollisionData("Enemy")
		local object = collision_data.collider:getObject()

		if object then
			object:hit(self.damage)
			self:explode()

			if object.hp <= 0 then
				GRoom.current_room.player.chance:onKill()
			end
		end
	end
end

function Projectile:updateHoming()
	-- Acquire new target if needed
	if not self.target then
		local targets = self.area:getAllGameObjectsThat(function(e)
			for _, enemy in ipairs(Enemies) do
				if e:is(_G[enemy]) and GlobalDistance(e.x, e.y, self.x, self.y) < HOMING_RANGE then
					return true
				end
			end
		end)

		if #targets > 0 then
			self.target = table.remove(targets, love.math.random(1, #targets))
		end
	end

	-- Clear dead targets
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
end

function Projectile:handleBounce(isSplit)
	if not self.bounce or self.bounce <= 1 then
		if self.x < 0 or self.x > GW or self.y < 0 or self.y > GH then
			self:die()
		end
		return
	end

	local randomOffset = math.rad(math.customRandom(-15, 15))
	local didBounce = false

	if self.x < 0 or self.x > GW then
		self.rotation = math.pi - self.rotation + randomOffset
		self.bounce = self.bounce - 1
		didBounce = true
	elseif self.y < 0 or self.y > GH then
		self.rotation = TWO_PI - self.rotation + randomOffset
		self.bounce = self.bounce - 1
		didBounce = true
	end

	if isSplit and didBounce then
		self:createSplitProjectiles()
	end
end

function Projectile:createSplitProjectiles()
	local baseRotation = self.rotation
	local rotations = {
		baseRotation + HALF_PI,
		baseRotation - HALF_PI
	}

	-- Add diagonal splits for 4Split
	if self.attack == "4Split" then
		table.insert(rotations, baseRotation + QUARTER_PI)
		table.insert(rotations, baseRotation - QUARTER_PI)
	end

	local projectileData = {
		bounce = self.bounce,
		parent = self.parent,
		velocity = self.velocity,
		damage = self.damage,
		distance = self.distance,
		form = self.formTear,
		attack = self.attack
	}

	for _, rot in ipairs(rotations) do
		projectileData.rotation = rot
		self.parent.area:addGameObject(
			"Projectile",
			self.x + math.cos(rot),
			self.y + math.sin(rot),
			projectileData
		)
	end
end

function Projectile:updateShield(dt)
	self.time = self.time + dt
	self.collider:setPosition(
		self.parent.x + self.orbit_distance * math.cos(self.orbit_speed * self.time + self.orbit_offset),
		self.parent.y + self.orbit_distance * math.sin(self.orbit_speed * self.time + self.orbit_offset)
	)

	self.invisible = true

	if self.attack == "Blast" then
		self.timer:after(6, function() self:die() end)
	else
		self.timer:after(0.05, function() self.invisible = false end)
	end

	self.timer:after(4, function() self:die() end)
end

function Projectile:update(dt)
	Projectile.super.update(self, dt)
	self.t = self.t + dt * self.speed -- parameter progression
	self:checkCollision()

	-- Attack-specific behavior
	if self.attack == "Homing" or self.attack == "Destroyer" then
		self:updateHoming()
	elseif self.attack == "Blast" then
		self.damage = 75
		self.color = table.random(G_negative_colors)
		self.timer:tween(math.customRandom(0.4, 0.6), self, { velocity = 0 }, 'linear', function() self:die() end)
	elseif self.attack == "Spin" then
		self.rotation = self.rotation + self.rv * dt
	elseif self.attack == "Bounce" then
		self:handleBounce(false)
	elseif self.attack == "2Split" or self.attack == "4Split" then
		self:handleBounce(true)
	elseif self.attack == "Explode" then
		if self.x < 0 or self.x > GW or self.y < 0 or self.y > GH then
			self:die()
			self.parent.area:addGameObject("Explosion", self.x, self.y, {
				color = self.color,
				rotation = self.parent.rotation
			})
		end
	end

	-- Shield behavior
	if self.shield then
		self:updateShield(dt)
	end

	-- Update velocity for non-homing projectiles
	if self.attack ~= "Homing" and self.attack ~= "Destroyer" then
		self.collider:setLinearVelocity(
			self.velocity * math.cos(self.rotation),
			self.velocity * math.sin(self.rotation)
		)
	end

	-- Boundary check for most projectiles
	if self.attack ~= "Bounce" and self.attack ~= "2Split" and self.attack ~= "4Split" then
		if self.x < 0 or self.x > GW or self.y < 0 or self.y > GH then
			print("projectile gonna die")
			self:die()
		end
	end
end

function Projectile:draw()
	if self.invisible then return end

	if self.attack == 'Bounce' then
		love.graphics.setColor(table.random(G_default_colors))
	else
		love.graphics.setColor(self.color)
	end

	local drawForm = self.form or Attacks["Neutral"].resource
	drawForm(self.x, self.y, self.radiusSpace, self.radiusSpace)

	love.graphics.setColor(G_default_color)
end

function Projectile:die()
	self.dead = true
	self.area:addGameObject("ProjectileDeathEffect", self.x, self.y, {
		color = self.color,
		w = 3 * self.radiusSpace
	})
end

function Projectile:explode()
	self.dead = true
	self.area:addGameObject("ExplodeParticle", self.x, self.y, {
		color = self.color,
		w = 3 * self.radiusSpace
	})
end
