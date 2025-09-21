PlayerChanceManager = Object:extend()

function PlayerChanceManager:new(player)
	self.player = player
	if not self.player then
		error("PlayerChanceManager needs a player!")
	end

	-- LUCK
	self.luckMultiplier = 1

	self.spawn_hp_on_cycle_chance = 100
	self.regain_hp_on_cycle_chance = 100
	self.regain_full_ammo_on_cycle_chance = 1
	self.change_attack_on_cycle_chance = 10
	self.spawn_haste_area_on_cycle_chance = 1
	self.barrage_on_cycle_chance = 100
	self.launch_homing_projectile_on_cycle_chance = 1
	self.regain_ammo_on_kill_chance = 100
	self.launch_homing_projectile_on_kill_chance = 100
	self.regain_boost_on_kill_chance = 100

	self.spawn_haste_area_on_sp_pickup_chance = 100

	-- IMPLEMENTEAD
	self.spawn_haste_area_on_hp_pickup_chance = 100

	self.aspd_boost_on_kill_chance = 100
	self.gain_some_hp_chance = 100
	self.gain_full_hp_chance = 100
	self.spawn_boost_on_kill_chance = 100
	self.barrage_on_kill_chance = 100
	self.launch_homing_projectile_on_ammo_pickup_chance = 50

	self.projectile_ninety_degree_change = 100

end

function PlayerChanceManager:returnRandomOffset()
	local xOffset = GlobalRandom(-1, 10)
	local yOffset = GlobalRandom(-10, 10)
	return xOffset, yOffset
end

--- Generates chance lists for all numeric fields in the Player object whose keys contain "_chance".
-- Iterates over the Player's fields, and for each field with a key containing "_chance" and a numeric value,
-- creates a chance list using `CreateChanceList` with the value as the probability for `true` and the remainder for `false`.
-- The generated chance lists are stored in the `self.chances` table, keyed by the original field name.
function PlayerChanceManager:generateChances()
	self.chances = {}
	for k, v in pairs(self) do
		if k:find("_chance") and type(v) == "number" then
			self.chances[k] = CreateChanceList(
				{ true, math.ceil(v * self.luckMultiplier) },
				{ false, 100 - math.ceil(v * self.luckMultiplier) }
			)
		end
	end
end

function PlayerChanceManager:getChance() end

function PlayerChanceManager:onAmmoPickupChance()
	local xOffset, yOffset = self:returnRandomOffset()
	if self.chances.launch_homing_projectile_on_ammo_pickup_chance:next() then
		local distance = 1.2 * self.player.w
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + distance * math.cos(self.player.rotation),
			self.player.y + distance * math.sin(self.player.rotation),
			{ rotation = self.player.rotation, attack = "Homing" }
		)
		self.player.area:addGameObject(
			"InfoText",
			self.player.x + xOffset,
			self.player.y + yOffset,
			{ text = "Homing Projectile!" }
		)
	end

	if self.chances.spawn_haste_area_on_hp_pickup_chance:next() then
		self.player.area:addGameObject(
			"HasteArea",
			GlobalRandom(self.player.x - gw / 2, self.player.x + gw / 2),
			GlobalRandom(self.player.y - gh / 2, self.player.y + gh / 2),
			{ parent = self.player }
		)
		self.player.area:addGameObject(
			"InfoText",
			self.player.x + xOffset,
			self.player.y + yOffset,
			{ text = "GO TO HASTE-AREA !" }
		)
	end
end

function PlayerChanceManager:onBoostPickupChange()
	local xOffset, yOffset = self:returnRandomOffset()

	if self.chances.spawn_boost_on_kill_chance:next() then
		local distance = 1.2 * self.player.w
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + distance * math.cos(self.player.rotation),
			self.player.y + distance * math.sin(self.player.rotation),
			{ rotation = self.player.rotation, attack = "Destroyer" }
		)
		self.player.area:addGameObject(
			"InfoText",
			self.player.x + xOffset,
			self.player.y + yOffset,
			{ text = "KILLER !" }
		)
	end
end

function PlayerChanceManager:onKill()
	local xOffset, yOffset = self:returnRandomOffset()

	if self.chances.barrage_on_kill_chance:next() then
		for i = 1, 8 do
			self.player.timer:after((i - 1) * 0.05, function()
				local random_angle = GlobalRandom(-math.pi / 8, math.pi / 8)
				local distance = 2.2 * self.player.w
				self.player.area:addGameObject(
					"Projectile",
					self.player.x + distance * math.cos(self.player.rotation + random_angle),
					self.player.y + distance * math.sin(self.player.rotation + random_angle),
					{
						rotation = self.player.rotation + random_angle,
						attack = self.player.attack,
						parent = self.player,
					}
				)
			end)
		end
		self.player.area:addGameObject(
			"InfoText",
			self.player.x + xOffset,
			self.player.y + yOffset,
			{ text = "BARRAGE !!!" }
		)
	end

	-- if self.chances.aspd_boost_on_kill_chance:next() then
	--     self.pre_boost_aspd_multiplier = self.aspd_multiplier
	-- 	self.aspd_multiplier = self.aspd_multiplier/2
	-- 	self.timer:after(4, function()
	--   	    self.aspd_multiplier = self.pre_boost_aspd_multiplier
	--         self.pre_boost_aspd_multiplier = nil
	--   	end)
	-- end
end

function PlayerChanceManager:onGainSomeHp()
	local xOffset, yOffset = self:returnRandomOffset()

	if self.chances.gain_some_hp_chance:next() then
		self.player.hp = math.min(self.player.max_hp, self.player.hp + 25)
		self.player.area:addGameObject(
			"InfoText",
			self.player.x + xOffset,
			self.player.y + yOffset,
			{ text = "SOME LIFE FOR HOMIE !" }
		)
	end
	if self.chances.gain_full_hp_chance:next() then
		self.player.hp = self.player.max_hp
		self.player.area:addGameObject(
			"InfoText",
			self.player.x + xOffset,
			self.player.y + yOffset,
			{ text = "FULL LIFE FOR BROS !" }
		)
	end
end

function PlayerChanceManager:onFreakProjectileDirection()
	self.player.freakShot = true
			self.player.area:addGameObject(
			"InfoText",
			self.player.x,
			self.player.y,
			{ text = "FREAK ASS SHOT !" }
		)
end