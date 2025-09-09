ProjectileDirector = Object:extend()

function ProjectileDirector:new(player)
	self.player = player
	self.attack = "Neutral"
	self.damage = 1
	self.color = { 1, 1, 1, 1 }
	self.size = 5
	self.velocity = 300
	self.formTear = {}
	table.insert(self.formTear, function(x, y)
		DraftDrawer:circle(x, y, self.size, "line")
	end) -- <-- try to map
end

function ProjectileDirector:updateAttack(key)
	if Attacks[key] then
		self.attack = Attacks[key].damage + self.damage
		self.damage = Attacks[key].damage
		self.color = InterpolateColor(Attacks[key].color, self.color, GlobalRandom(0, 1))
		self.resource = Attacks[key].resource
		table.insert(self.formTear, Attacks[key].resource)
	
    end
end

function ProjectileDirector:shoot(distance)
	self.player.area:addGameObject(
		"Projectile",
		self.x + 1.5 * distance * math.cos(self.rotation),
		self.y + 1.5 * distance * math.sin(self.rotation),
		{ player = self, distance = distance, attack = self.attack } -- {self.attack.color[1],self.attack.color[2],self.attack.color[3],self.attack.color[4]}
	)
end
