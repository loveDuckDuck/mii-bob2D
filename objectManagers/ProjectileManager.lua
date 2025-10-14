ProjectileManager = Object:extend()

function ProjectileManager:new(player)
	self.player = player
	self.attack = "Neutral"
	self.damage = 1
	self.color = { 0.1, 0.1, 0.1, 1 }
	self.size = 5
	self.sizeMultilplier = 1
	self.shootAngle = 0
	self.tearIterator = 1
	self.velocity = 300
	self.velocityMultilplier = 1
	self.formTear = {}
	self.projectile_ninety_degree_change = false
	self.wavy_projectiles = false
	self.fast_slow = false
	self.slow_fast = false
	self.shield = false
	self.bounce = 4
	self.stats = {}
	self.mods = {}

	self:initAttackPatterns()
end

function ProjectileManager:initAttackPatterns()
	self.attackPatterns = {
		Neutral = function(distance)
			self:createProjectile(distance)
		end,

		Double = function(distance)
			self:createProjectile(distance, math.pi / 12)
			self:createProjectile(distance, -math.pi / 12)
		end,

		Triple = function(distance)
			self:createProjectile(distance, 0)
			self:createProjectile(distance, math.pi / 12)
			self:createProjectile(distance, -math.pi / 12)
		end,

		Rapid = function(distance)
			self:createProjectile(distance)
		end,

		Spread = function(distance)
			local randomAngle = math.customRandom(-math.pi / 8, math.pi / 8)
			self:createProjectile(distance, randomAngle)
		end,

		Back = function(distance)
			self:createProjectile(distance, 0)
			self:createProjectile(distance, math.pi)
		end,

		Side = function(distance)
			self:createProjectile(distance, 0)
			self:createProjectile(distance, -math.pi / 2)
			self:createProjectile(distance, math.pi / 2)
		end,

		Homing = function(distance)
			self:createProjectile(distance)
		end,

		Destroyer = function(distance)
			self:createProjectile(distance)
		end,

		Blast = function(distance)
			for i = 1, 12 do
				local randomAngle = math.customRandom(-math.pi / 6, math.pi / 6)
				self:createProjectile(distance, randomAngle, { velocity = math.customRandom(500, 600) })
			end
			GCamera:shake(4, 60, 0.4)
		end,

		Lightning = function(distance)
			local x1 = self.player.x + distance * math.cos(self.player.rotation)
			local y1 = self.player.y + distance * math.sin(self.player.rotation)
			local cx = x1 + 24 * math.cos(self.player.rotation)
			local cy = y1 + 24 * math.sin(self.player.rotation)

			local nearby_enemies = self.player.area:getAllGameObjectsThat(function(e)
				for _, enemy in ipairs(Enemies) do
					if e:is(_G[enemy]) and (GlobalDistance(e.x, e.y, cx, cy) < 64) then
						return true
					end
				end
			end)

			table.sort(nearby_enemies, function(a, b)
				return GlobalDistance(a.x, a.y, cx, cy) < GlobalDistance(b.x, b.y, cx, cy)
			end)

			local closest_enemy = nearby_enemies[1]
			if closest_enemy then
				closest_enemy:hit(self.damage)
				local x2, y2 = closest_enemy.x, closest_enemy.y
				self.player.area:addGameObject('LightningLine', 0, 0, { x1 = x1, y1 = y1, x2 = x2, y2 = y2 })

				for i = 1, love.math.random(4, 8) do
					self.player.area:addGameObject('ExplodeParticle', x1, y1,
						{ color = table.random({ GDefaultColor, GBoostColor }) })
				end
				for i = 1, love.math.random(4, 8) do
					self.player.area:addGameObject('ExplodeParticle', x2, y2,
						{ color = table.random({ GDefaultColor, GBoostColor }) })
				end
			end
		end
	}
end

function ProjectileManager:updateAttack(key)
	if Attacks[key] then
		self.attack = key
		self.damage = Attacks[key].damage
		self.color = Attacks[key].color 
		self.tearIterator = Attacks[key].tears
		self.shootAngle = Attacks[key].shootAngle or 0
		self.formTear = Attacks[key].resource
	end
end

function ProjectileManager:update(dt)
	if self.player.ammo <= 0 and Attacks[self.attack].ammo > 0 then
		self.player:setAttack("Neutral")
	end
end

-- Helper function to create a projectile at a given angle offset
function ProjectileManager:createProjectile(distance, angleOffset, extraParams)
	angleOffset = angleOffset or 0
	extraParams = extraParams or {}

	local angle = self.player.rotation + angleOffset
	local x = self.player.x + 1.5 * distance * math.cos(angle)
	local y = self.player.y + 1.5 * distance * math.sin(angle)

	local params = table.merge(self.stats, self.mods)
	params = table.merge(params, { rotation = angle })
	params = table.merge(params, extraParams)

	self.player.area:addGameObject("Projectile", x, y, params)
end



function ProjectileManager:shoot(distance)
	-- Prepare mods and stats
	self.mods = {
		shield = self.shield,
		projectile_ninety_degree_change = self.projectile_ninety_degree_change,
		wavy_projectiles = self.wavy_projectiles,
		slow_fast = self.slow_fast,
		fast_slow = self.fast_slow,
		bounce = self.bounce
	}

	self.stats = {
		parent = self.player,
		velocity = self.velocity * self.velocityMultilplier,
		damage = self.damage,
		color = self.color,
		distance = distance,
		attack = self.attack,
		form = self.formTear
	}

	-- Execute attack pattern
	local pattern =  self.attackPatterns[self.attack]
	if pattern then
		pattern(distance)
	else
		-- Default fallback
		self:createProjectile(distance)
	end
end
