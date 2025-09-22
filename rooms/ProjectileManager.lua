ProjectileManager = Object:extend()

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
	}
	if self.attack == "Neutral" then
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation),
			table.merge({
				parent = self.player,
				rotation = self.player.rotation,
				velocity = self.velocity * self.velocityMultilplier,
				damage = self.damage,
				color = self.color,
				distance = distance,
				attack = self.attack,
				form = self.formTear,
				projectileManager = self,
			}, self.mods)
		)
	elseif self.attack == "Double" then
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation + math.pi / 12),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation + math.pi / 12),
			{
				parent = self.player,
				rotation = self.player.rotation,
				velocity = self.velocity * self.velocityMultilplier,
				damage = self.damage,
				color = self.color,
				distance = distance,
				attack = self.attack,
				form = self.formTear,
				projectileManager = self,
			}
		)
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation - math.pi / 12),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation - math.pi / 12),
			{
				parent = self.player,
				rotation = self.player.rotation,
				velocity = self.velocity * self.velocityMultilplier,
				damage = self.damage,
				color = self.color,
				distance = distance,
				attack = self.attack,
				form = self.formTear,
				projectileManager = self,
			}
		)
	elseif self.attack == "Triple" then
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation),
			{
				parent = self.player,
				rotation = self.player.rotation,
				velocity = self.velocity * self.velocityMultilplier,
				damage = self.damage,
				color = self.color,
				distance = distance,
				attack = self.attack,
				form = self.formTear,
				projectileManager = self,
			}
		)
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation + math.pi / 12),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation + math.pi / 12),
			{
				parent = self.player,
				rotation = self.player.rotation + math.pi / 12,
				velocity = self.velocity * self.velocityMultilplier,
				damage = self.damage,
				color = self.color,
				distance = distance,
				attack = self.attack,
				form = self.formTear,
				projectileManager = self,
			}
		)
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation - math.pi / 12),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation - math.pi / 12),
			{
				parent = self.player,
				rotation = self.player.rotation - math.pi / 12,
				velocity = self.velocity * self.velocityMultilplier,
				damage = self.damage,
				color = self.color,
				distance = distance,
				attack = self.attack,
				form = self.formTear,
				projectileManager = self,
			}
		)
	elseif self.attack == "Rapid" then
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation),
			{
				parent = self.player,
				rotation = self.player.rotation,
				velocity = self.velocity * self.velocityMultilplier,
				damage = self.damage,
				color = self.color,
				distance = distance,
				attack = self.attack,
				form = self.formTear,
				projectileManager = self,
			}
		)
	elseif self.attack == "Spread" then
		local randomAngle = GlobalRandom(-math.pi / 8, math.pi / 8)
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation + randomAngle),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation + randomAngle),
			{
				parent = self.player,
				rotation = self.player.rotation + randomAngle,
				velocity = self.velocity * self.velocityMultilplier,
				damage = self.damage,
				color = self.color,
				distance = distance,
				attack = self.attack,
				form = self.formTear,
				projectileManager = self,
			}
		)
	elseif self.attack == "Back" then
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation),
			{
				parent = self.player,
				rotation = self.player.rotation,
				velocity = self.velocity * self.velocityMultilplier,
				damage = self.damage,
				color = self.color,
				distance = distance,
				attack = self.attack,
				form = self.formTear,
				projectileManager = self,
			}
		)
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation - math.pi),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation - math.pi),
			{
				parent = self.player,
				rotation = self.player.rotation - math.pi,
				velocity = self.velocity * self.velocityMultilplier,
				damage = self.damage,
				color = self.color,
				distance = distance,
				attack = self.attack,
				form = self.formTear,
				projectileManager = self,
			}
		)
	elseif self.attack == "Side" then
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation),
			{
				parent = self.player,
				rotation = self.player.rotation,
				velocity = self.velocity * self.velocityMultilplier,
				damage = self.damage,
				color = self.color,
				distance = distance,
				attack = self.attack,
				form = self.formTear,
				projectileManager = self,
			}
		)
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation - math.pi / 2),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation - math.pi / 2),
			{
				parent = self.player,
				rotation = self.player.rotation - math.pi / 2,
				velocity = self.velocity * self.velocityMultilplier,
				damage = self.damage,
				color = self.color,
				distance = distance,
				attack = self.attack,
				form = self.formTear,
				projectileManager = self,
			}
		)
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation + math.pi / 2),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation + math.pi / 2),
			{
				parent = self.player,
				rotation = self.player.rotation + math.pi / 2,
				velocity = self.velocity * self.velocityMultilplier,
				damage = self.damage,
				color = self.color,
				distance = distance,
				attack = self.attack,
				form = self.formTear,
				projectileManager = self,
			}
		)
	elseif self.attack == "Homing" then
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation),
			{
				parent = self.player,
				rotation = self.player.rotation,
				velocity = self.velocity * self.velocityMultilplier,
				damage = self.damage,
				color = self.color,
				distance = distance,
				attack = self.attack,
				form = self.formTear,
				projectileManager = self,
			}
		)
	elseif self.attack == "Destroyer" then
		self.player.area:addGameObject(
			"Projectile",
			self.player.x + 1.5 * distance * math.cos(self.player.rotation),
			self.player.y + 1.5 * distance * math.sin(self.player.rotation),
			{
				parent = self.player,
				rotation = self.player.rotation,
				velocity = self.velocity * self.velocityMultilplier,
				damage = self.damage,
				color = self.color,
				distance = distance,
				attack = self.attack,
				form = self.formTear,
				projectileManager = self,
			}
		)
	end
end
