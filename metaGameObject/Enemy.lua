Enemy = GameObject:extend()

function Enemy:new(area, x, y, opts)
	Enemy.super.new(self, area, x, y, opts)
	self.name = opts.name or "Enemy"
	self.hp = opts.hp or 5
	self.w, self.h = 8, 8
end

function Enemy:update(dt)
	Enemy.super.update(self, dt)
	if self.x < 0 - 100 or self.y < 0  - 100 or self.x > GW + 100 or self.y > GH + 100 then
		self.dead = true
	end
end

function Enemy:draw() end

function Enemy:hit(damage)
	self.hp = self.hp - damage
	if self.hp <= 0 then
		self:die()
	end
end

function Enemy:die()
	self.dead = true
	self.area:addGameObject("InfoText", self.x, self.y, { text = self.name, color = GHPColor })
	self.area:addGameObject("EnemyDeathEffect", self.x, self.y, { color = GHPColor, w = self.w, h = self.h })
	self.area:addGameObject("Ammo", self.x, self.y)
end
