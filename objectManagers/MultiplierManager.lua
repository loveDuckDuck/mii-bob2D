MultiplierManager = Object:extend()

function MultiplierManager:new(player)
	if player then
		self.player = player
	end
	self.random = 0
	self.hp_multiplier = 60
	self.luckMultiplier = 90
	self.damage_multiplier = 90
	self.size_multiplier = 90
	self.velocity_multiplier = 90

	self.friction_multiplier = 50
	self.shoot_cooldown_timer_multiplier = 50
	-- TO IMPLEMENTEAD
	self.enemy_spawn_rate_multiplier = 1
	self.resource_spawn_rate_multiplier = 1
	self.attack_spawn_rate_multiplier = 1
	self.turn_rate_multiplier = 1

	self.boost_effectiveness_multiplier = 50
	self.projectile_size_multiplier = 50
	self.boost_recharge_rate_multiplier = 50
	self.invulnerability_time_multiplier = 50
	self.ammo_consumption_multiplier = 50
	self.stat_boost_duration_multiplier = 50
	self.projectile_duration_multiplier = 50
	self.all_colors = Moses.append(GDefaultColors, G_negative_colors)
end

--- Generates chance lists for all numeric fields in the Player object whose keys contain "_chance".
-- Iterates over the Player's fields, and for each field with a key containing "_chance" and a numeric value,
-- creates a chance list using `CreateChanceList` with the value as the probability for `true` and the remainder for `false`.
-- The generated chance lists are stored in the `self.chances` table, keyed by the original field name.
function MultiplierManager:generateChanceMultiplier()
	self.chances = {}
	for k, v in pairs(self) do
		if k:find("_multiplier") and type(v) == "number" then
			self.chances[k] = CreateChanceList(
				{ true, math.ceil(v) },
				{ false, 100 - math.ceil(v) }
			)
		end
	end
end

function MultiplierManager:onAmmoPickupChance()
	self.random = math.customRandom(0.1, 0.5)
	local fiftyFifty = math.random(0, 100)

	local color = { math.random(0.1, 1.0), math.random(0.1, 1.0), math.random(0.1, 1.0), math.random(0.1, 1.0) }
	if self.chances.hp_multiplier:next() then
		self.player.max_hp = self.player.max_hp + self.player.max_hp * self.random
		self.player.hp = self.player.hp + self.player.hp * self.random

		self:printText("LIFE HOE", 2, color)
	end
	if self.chances.velocity_multiplier:next() then
		self.player.acceleration = ReturnValuePercentage(self.player.acceleration, self.random, fiftyFifty)
		self.player.baseMaxVelocity = ReturnValuePercentage(self.player.baseMaxVelocity, self.random, fiftyFifty)
		self.player.maxVelocity = ReturnValuePercentage(self.player.maxVelocity, self.random, fiftyFifty)

        -- clamp friction to avoid dt * friction >= 1 (which would zero velocities each physics step)
        local newFriction = ReturnValuePercentage(self.player.friction, self.random, fiftyFifty)
        self.player.friction = math.max(0.01, math.min(newFriction, 60)) -- adjust upper limit as needed


		self:printText(fiftyFifty < 50 and "FASTER!@R" or "slowwwwwwwwwwwwwwwww", 2, color)
	end

	if self.chances.damage_multiplier:next() then
		self.player.projectileManager.damage = ReturnValuePercentage(self.player.projectileManager.damage, self.random,
			fiftyFifty)
		print(self.player.projectileManager.damage)
		self:printText(fiftyFifty < 50 and "KILLLLLLL!!!" or "im gonna bee killed", 2, color)
	end

	if self.chances.size_multiplier:next() then
		self.player.projectileManager.size = ReturnValuePercentage(self.player.projectileManager.size, self.random,
			fiftyFifty)

		self:printText(fiftyFifty < 50 and "BIGGER!" or "smallllllll", 2, color)
	end
end

function MultiplierManager:destroy()
	table.clear(self)
end

function MultiplierManager:printText(text, scaleFactor, color)
	local offsetX = math.random(0, GW)
	local offsetY = math.random(0, GH)
	local color = self.all_colors[math.random(1, #self.all_colors)]


	self.player.area:addGameObject("InfoText", offsetX, offsetY,
		{
			text = text,
			color = color,
			scaleFactor = SX,

		})
end
