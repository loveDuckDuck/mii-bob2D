Enemy = GameObject:extend()

function Enemy:new(area, x, y, opts)
	Enemy.super.new(self, area, x, y, opts)
	self.name = opts.name or "Enemy"
	self.hp = opts.hp or 10
	self.w, self.h = 8, 8
end

function Enemy:update(dt)
	Enemy.super.update(self, dt)
end

function Enemy:draw() end

function Enemy:hit(damage)
	self.hp = self.hp - damage
	print("Enemy : ", damage)
	if self.hp <= 0 then
		self:die()
	end
end

function Enemy:die()
	self.dead = true
	self.area:addGameObject("InfoText", self.x, self.y, { text = self.name, color = G_hp_color })
	self.area:addGameObject("EnemyDeathEffect", self.x, self.y, { color = G_hp_color, w = self.w, h = self.h })
	self.area:addGameObject("Ammo", self.x, self.y)
end
