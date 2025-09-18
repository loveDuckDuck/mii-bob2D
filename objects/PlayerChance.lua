PlayerChance = Object:extend()

function PlayerChance:new(player)
	self.player = player
    if not self.player then
        error("PlayerChance needs a player!")
    end
	self.launch_homing_projectile_on_ammo_pickup_chance = 50
	self.spawn_hp_on_cycle_chance = 1
	self.regain_hp_on_cycle_chance = 100
	self.regain_full_ammo_on_cycle_chance = 1
	self.change_attack_on_cycle_chance = 10
	self.spawn_haste_area_on_cycle_chance = 1
	self.barrage_on_cycle_chance = 1
	self.launch_homing_projectile_on_cycle_chance = 1
	self.regain_ammo_on_kill_chance = 100
	self.launch_homing_projectile_on_kill_chance = 100
	self.regain_boost_on_kill_chance = 100
	self.spawn_boost_on_kill_chance = 100
end


--- Generates chance lists for all numeric fields in the Player object whose keys contain "_chance".
-- Iterates over the Player's fields, and for each field with a key containing "_chance" and a numeric value,
-- creates a chance list using `CreateChanceList` with the value as the probability for `true` and the remainder for `false`.
-- The generated chance lists are stored in the `self.chances` table, keyed by the original field name.
function PlayerChance:generateChances()
	self.chances = {}
	for k, v in pairs(self) do
		if k:find("_chance") and type(v) == "number" then
			self.chances[k] = CreateChanceList({ true, math.ceil(v) }, { false, 100 - math.ceil(v) })
		end
	end
end

function PlayerChance:getChance() end

function PlayerChance:onAmmoPickupChance()
	if self.chances.launch_homing_projectile_on_ammo_pickup_chance:next() then
		local distance = 1.2 * self.player.w
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + distance * math.cos(self.player.rotation),
			self.player.y + distance * math.sin(self.player.rotation),
			{ rotation = self.player.rotation, attack = "Homing" }
		)
		self.player.area:addGameObject("InfoText", self.player.x, self.player.y, { text = "Homing Projectile!" })
	end
end

function PlayerChance:onBoostPickupChange()
	if self.chances.spawn_boost_on_kill_chance:next() then
		local distance = 1.2 * self.player.w
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + distance * math.cos(self.player.rotation),
			self.player.y + distance * math.sin(self.player.rotation),
			{ rotation = self.player.rotation, attack = "Destroyer" }
		)
		self.player.area:addGameObject("InfoText", self.player.x, self.player.y, { text = "KILLER !" })
	end


end



