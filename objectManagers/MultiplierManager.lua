MultiplierManager = Object:extend()

function MultiplierManager:new(player)
	if player then
		self.player = player
	end

	self.random = 0
	self.hp_multiplier = 50
	self.luckMultiplier = 50

	self.velocity_multiplier = 50
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
	self.size_multiplier = 50
	self.stat_boost_duration_multiplier = 50
	self.projectile_duration_multiplier = 50
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
	self.random = math.random(0.005, 0.01)
	local color = { math.random(0.1, 1.0), math.random(0.1, 1.0), math.random(0.1, 1.0), math.random(0.1, 1.0) }
	if self.chances.hp_multiplier:next() then
		self.player.max_hp = self.player.max_hp + self.player.max_hp * self.random
		self.player.hp = self.player.hp + self.player.hp * self.random

		self.player.area:addGameObject("InfoText", self.player.x, self.player.y,
			{ text = "LIFE HOE", color = color })
	end
	if self.chances.velocity_multiplier:next() then
		self.player.acceleration = self.player.acceleration + self.player.acceleration * self.random
		self.player.baseMaxVelocity = self.player.baseMaxVelocity + self.player.baseMaxVelocity * self.random
		self.player.maxVelocity = self.player.maxVelocity + self.player.maxVelocity * self.random
		self.player.friction = self.player.friction - self.player.friction * self.random 
		self.player.area:addGameObject("InfoText", self.player.x, self.player.y,
			{ text = "FASTER!@R", color = color })
	end
	if self.chances.friction_multiplier:next() then
		self.player.acceleration = self.player.acceleration - self.player.acceleration * self.random
		self.player.baseMaxVelocity = self.player.baseMaxVelocity - self.player.baseMaxVelocity * self.random
		self.player.maxVelocity = self.player.maxVelocity - self.player.maxVelocity * self.random
		self.player.friction = self.player.friction + self.player.friction * self.random 
		self.player.area:addGameObject("InfoText", self.player.x, self.player.y,
			{ text = "SLOWWER BORTHA!", color = color })
	end
end
