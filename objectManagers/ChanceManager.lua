ChanceManager = Object:extend()

function ChanceManager:new(player, projectileManager)
	self.player = player
	if not self.player then
		error("ChanceManager needs a player!")
	end
	self.projectileManager = projectileManager
	if not self.projectileManager then
		error("ChanceManager needs a projectileManager!")
	end

	-- LUCK
	self.luckMultiplier = 1

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

	-- IMPLEMENTEAD WHEN I PICK UP A AMMO
	-- SO THIS IMPLEMENTATION DOESNT AFFECT MY PLAYER
	-- JUST ONLY SPAWN SOMETHING
	self.spawn_haste_area_on_hp_pickup_chance = 50
	self.aspd_boost_on_kill_chance = 50
	self.gain_some_hp_chance = 50
	self.gain_full_hp_chance = 50
	self.spawn_boost_on_kill_chance = 50
	self.barrage_on_kill_chance = 50
	self.launch_homing_projectile_on_ammo_pickup_chance = 50
	self.projectile_ninety_degree_change_chance = 50

	-- SPAWNER ELEMENT
	self.spawn_hp_coin_chance = 100
	self.spawn_barrier_chance = 100




	-- MODIFIER
	self.wavy_projectiles_chance = 100
	self.shield_projectile_chance = 100
end

function ChanceManager:returnRandomOffset()
	local xOffset = math.customRandom(-1, 10)
	local yOffset = math.customRandom(-10, 10)
	return xOffset, yOffset
end

--- Generates chance lists for all numeric fields in the Player object whose keys contain "_chance".
-- Iterates over the Player's fields, and for each field with a key containing "_chance" and a numeric value,
-- creates a chance list using `CreateChanceList` with the value as the probability for `true` and the remainder for `false`.
-- The generated chance lists are stored in the `self.chances` table, keyed by the original field name.
function ChanceManager:generateChances()
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

function ChanceManager:getChance() end

function ChanceManager:onAmmoPickupChance()
	local xOffset, yOffset = self:returnRandomOffset()
	if self.chances.launch_homing_projectile_on_ammo_pickup_chance:next()

	then
		local distance = 1.2 * self.player.w
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + distance * math.cos(self.player.rotation),
			self.player.y + distance * math.sin(self.player.rotation),
			{ rotation = self.player.rotation, attack = "Homing", color = math.threeRamdon() }
		)
		self.player.area:addGameObject(
			"InfoText",
			self.player.x + xOffset,
			self.player.y + yOffset,
			{ text = "Homing Projectile!", color = math.threeRamdon() }
		)
	end

	if self.chances.spawn_haste_area_on_hp_pickup_chance:next() then
		self.player.area:addGameObject(
			"HasteArea",
			math.customRandom(self.player.x - GW / 2, self.player.x + GW / 2),
			math.customRandom(self.player.y - GH / 2, self.player.y + GH / 2),
			{ parent = self.player }
		)
		self.player.area:addGameObject(
			"InfoText",
			self.player.x + xOffset,
			self.player.y + yOffset,
			{ text = "GO TO HASTE-AREA !", color = math.threeRamdon() }
		)
	end


	if self.chances.spawn_barrier_chance:next() then
		self.player.area:addGameObject(
			"BarrierArea",
			self.player.x,
			self.player.y,
			{ parent = self.player }
		)
		self.player.area:addGameObject(
			"InfoText",
			self.player.x + xOffset,
			self.player.y + yOffset,
			{ text = "PROTECTED", color = math.threeRamdon() }
		)
	end

	self:onBoostPickupChange()
end

function ChanceManager:onBoostPickupChange()
	local xOffset, yOffset = self:returnRandomOffset()

	if self.chances.spawn_boost_on_kill_chance:next() then
		local distance = 1.2 * self.player.w
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + distance * math.cos(self.player.rotation),
			self.player.y + distance * math.sin(self.player.rotation),
			{ rotation = self.player.rotation, attack = "Destroyer", color = Attacks["Destroyer"].color }
		)
		self.player.area:addGameObject(
			"InfoText",
			self.player.x + xOffset,
			self.player.y + yOffset,
			{ text = "KILLER !",  color = Attacks["Destroyer"].color }
		)
	end
end

function ChanceManager:onKill()
	local xOffset, yOffset = self:returnRandomOffset()

	if self.chances.barrage_on_kill_chance:next() then
		--avoid errors
		if self.player.timer then
			for i = 1, 8 do
				self.player.timer:after((i - 1) * 0.05, function()
					local random_angle = math.customRandom(-math.pi / 8, math.pi / 8)
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
		end
		self.player.area:addGameObject(
			"InfoText",
			self.player.x + xOffset,
			self.player.y + yOffset,
			{ text = "BARRAGE !!!" }
		)
	end

	if self.chances.spawn_hp_coin_chance:next() then
		self.player.area:addGameObject(
			"HpCoin",
			self.player.x + xOffset * math.cos(self.player.rotation),
			self.player.y + yOffset * math.sin(self.player.rotation))
		self.player.area:addGameObject(
			"InfoText",
			self.player.x + xOffset,
			self.player.y + yOffset,
			{ text = "SOME GOOD LIFE !!!" }
		)
	end
end

function ChanceManager:onGainSomeHp()
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

function ChanceManager:onFreakProjectileDirection()
	if self.chances.projectile_ninety_degree_change_chance:next() then
		self.projectileManager.projectile_ninety_degree_change =
			not self.projectileManager.projectile_ninety_degree_change
		print("freakShot : " .. (self.projectileManager.projectile_ninety_degree_change and "YESS" or "NOOOO"))

		self.player.area:addGameObject("InfoText", self.player.x, self.player.y, { text = "FREAK ASS SHOT !" , color =  math.threeRamdon()})
	end
end

function ChanceManager:onWavyProjectilesChance()
	if self.chances.wavy_projectiles_chance:next() then
		self.projectileManager.wavy_projectiles = not self.projectileManager.wavy_projectiles
		print("WAVYY : " .. (self.projectileManager.wavy_projectiles and "YESS" or "NOOOO"))

		self.player.area:addGameObject("InfoText", self.player.x, self.player.y, { text = "WAVYYYYY !", color =  math.threeRamdon() })
	end
end

function ChanceManager:onShieldProjectileChance()
	if self.chances.shield_projectile_chance:next() then
		self.projectileManager.shield = not self.projectileManager.shield
		print("SHIELD : " .. (self.projectileManager.shield and "YESS" or "NO"))
		self.player.area:addGameObject("InfoText", self.player.x, self.player.y, { text = "PROTECTED !", color =  math.threeRamdon() })
	end
end

function ChanceManager:destroy()
	table.allNil(self)
end
