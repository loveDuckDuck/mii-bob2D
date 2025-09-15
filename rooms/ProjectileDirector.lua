ProjectileDirector = Object:extend()

function ProjectileDirector:new(player)
	self.player = player
	self.attack = "Neutral"

	self.damage = 1
	-- COLOR
	self.color = { 0.1, 0.1, 0.1, 1 }

	-- SIZE
	self.size = 5
	self.sizeMultilplier = 1
	self.shootAngle = 0
	self.iterations = 1
	--[[
-                       self.x + 1.5 * distance * math.cos(self.rotation - math.pi / 12),
-                       self.y + 1.5 * distance * math.sin(self.rotation - math.pi / 12)

]]

	-- SPEED
	self.velocity = 300
	self.velocityMultilplier = 1
	-- TEAR FORM
	self.formTear = {}

	table.insert(self.formTear, function(x, y)
		DraftDrawer:circle(x, y, self.size, "line")
	end) -- <-- try to map
end

function ProjectileDirector:updateAttack(key)
	if Attacks[key] then
		self.attack = key
		self.damage = Attacks[key].damage
		self.color = InterpolateColor(Attacks[key].color, self.color, GlobalRandom(0, 1))
		self.resource = Attacks[key].resource
		table.insert(self.formTear, Attacks[key].resource)
	end
end

function ProjectileDirector:shoot(distance)
	for i = 1, self.iterations, 1 do
		self.player.area:addGameObject(
			"Projectile",
			self.player.x
				+ 1.5
					* distance
					* math.cos(self.player.rotation + (i % 2 == 0 and self.shootAngle or -self.shootAngle)),
			self.player.y
				+ 1.5
					* distance
					* math.sin(self.player.rotation + (i % 2 == 0 and self.shootAngle or -self.shootAngle)),
			{
				parent = self.player,
				rotation = self.player.rotation,
				velocity = self.velocity * self.velocityMultilplier,
				damage = self.damage,
				color = self.color,
				distance = distance,
				attack = self.attack,
			}
		)
	end
end
