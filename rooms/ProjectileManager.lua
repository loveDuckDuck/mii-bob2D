ProjectileManager = Object:extend()
--[[
    TODO : FINISH THE ProjectileManager
]]
function ProjectileManager:new(player)
	self.player = player
	self.attack = "Neutral"

	self.damage = 1
	-- COLOR
	self.color = { 0.1, 0.1, 0.1, 1 }

	-- SIZE
	self.size = 5
	self.sizeMultilplier = 1
	self.shootAngle = 0
	self.tearIterator = 1
	-- SPEED
	self.velocity = 300
	self.velocityMultilplier = 1
	-- TEAR FORM
	self.formTear = {}

	-- MOVEMENT TEAR

	self.projectile_ninety_degree_change = false
	self.wavy_projectiles = false
	self.fast_slow = false
	self.slow_fast = false
	self.shield = false
	self.bounce = 4

	self.stats = {}
	self.mods = {}
end

function ProjectileManager:updateAttack(key)
	if Attacks[key] then
		self.attack = key
		self.damage = Attacks[key].damage
		self.color = InterpolateColor(Attacks[key].color, self.color, GlobalRandom(0, 1))
		self.tearIterator = Attacks[key].tears
		self.shootAngle = Attacks[key].shootAngle or 0
		self.formTear = Attacks[key].resource
		--table.insert(self.formTear, Attacks[key].resource)
	end
end

function ProjectileManager:update(dt)
	if self.player.ammo <= 0 and Attacks[self.attack].ammo > 0 then
		self.player:setAttack("Neutral")
	end
end

function ProjectileManager:shoot(distance)
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

	local statsMods = table.merge(self.stats, self.mods)

	if self.attack == "Neutral" then
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation),
			table.merge(statsMods, { rotation = self.player.rotation })
		)
	elseif self.attack == "Double" then
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation + math.pi / 12),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation + math.pi / 12),
			table.merge(statsMods, { rotation = self.player.rotation })
		)
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation - math.pi / 12),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation - math.pi / 12),
			table.merge(statsMods, { rotation = self.player.rotation })
		)
	elseif self.attack == "Triple" then
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation),
			table.merge(statsMods, { rotation = self.player.rotation })
		)
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation + math.pi / 12),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation + math.pi / 12),
			table.merge(statsMods, { rotation = self.player.rotation })
		)
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation - math.pi / 12),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation - math.pi / 12),
			table.merge(statsMods, { rotation = self.player.rotation })
		)
	elseif self.attack == "Rapid" then
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation),
			table.merge(statsMods, { rotation = self.player.rotation })
		)
	elseif self.attack == "Spread" then
		local randomAngle = GlobalRandom(-math.pi / 8, math.pi / 8)
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation + randomAngle),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation + randomAngle),
			table.merge(statsMods, { rotation = self.player.rotation + randomAngle })

		)
	elseif self.attack == "Back" then
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation),
			table.merge(statsMods, { rotation = self.player.rotation })
		)
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation - math.pi),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation - math.pi),
			table.merge(statsMods, { rotation = self.player.rotation - math.pi })

		)
	elseif self.attack == "Side" then
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation),
			table.merge(statsMods, { rotation = self.player.rotation })

		)
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation - math.pi / 2),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation - math.pi / 2),
			table.merge(statsMods, { rotation = self.player.rotation - math.pi / 2 })

		)
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation + math.pi / 2),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation + math.pi / 2),
			table.merge(statsMods, { rotation = self.player.rotation + math.pi / 2 })
		)
	elseif self.attack == "Homing" then
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation),
			table.merge(statsMods, { rotation = self.player.rotation })

		)
	elseif self.attack == "Destroyer" then
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation),
			table.merge(statsMods, { rotation = self.player.rotation })

		)
	elseif self.attack == "Blast" then
		for i = 1, 12 do
			local random_angle = GlobalRandom(-math.pi / 6, math.pi / 6)
			self.player.area:addGameObject('Projectile',
				self.player.x + 1.5 * distance * math.cos(self.player.rotation + random_angle),
				self.player.y + 1.5 * distance * math.sin(self.player.rotation + random_angle),
				table.merge(statsMods,
					{ rotation = self.player.rotation + random_angle, velocity = GlobalRandom(500, 600) }))
		end
		GlobalCamera:shake(4, 60, 0.4)
		--[[
	 self.attack == "Spin" or self.attack == "Flame"
	 or self.attack == "Bounce"
	 or self.attack == "2Split"
	 or self.attack ==  "4Split" then
		]]
	elseif self.attack == "Lightning" then
		local x1, y1 = self.player.x + distance * math.cos(self.player.rotation),
			self.player.y + distance * math.sin(self.player.rotation)
		local cx, cy = x1 + 24 * math.cos(self.player.rotation), y1 + 24 * math.sin(self.player.rotation)

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
		-- Attack closest enemy
		if closest_enemy then
			closest_enemy:hit(self.damage)
			local x2, y2 = closest_enemy.x, closest_enemy.y
			self.player.area:addGameObject('LightningLine', 0, 0, { x1 = x1, y1 = y1, x2 = x2, y2 = y2 })


			for i = 1, love.math.random(4, 8) do
				self.player.area:addGameObject('ExplodeParticle', x1, y1,
					{ color = table.random({ G_default_color, G_boost_color }) })
			end
			for i = 1, love.math.random(4, 8) do
				self.player.area:addGameObject('ExplodeParticle', x2, y2,
					{ color = table.random({ G_default_color, G_boost_color }) })
			end
		end
	
	
	else
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation),
			table.merge(statsMods, { rotation = self.player.rotation })
		)
	end
end
