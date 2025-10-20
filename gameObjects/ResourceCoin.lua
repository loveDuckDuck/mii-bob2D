-- No cmd() found.
ResourceCoin = CoinObject:extend()

function ResourceCoin:new(area, x, y, opts)
	ResourceCoin.super.new(self, area, x, y, opts)
	self.power = table.randomResource(Attacks)
	self.radius = math.random(7, 17)
	self.timer:tween(3, self, { radius = 1 }, 'in-out-cubic')
end

function ResourceCoin:update(dt)
	ResourceCoin.super.update(self, dt)
	if self.x < 0 or self.y < 0 or self.x > GW or self.y > GH then
		self:die()
	end
end

function ResourceCoin:draw()
	love.graphics.setColor(self.power.color)
	PushRotate(self.x, self.y, self.collider:getAngle())


	GDraft:circle(self.x, self.y, self.radius, nil, "fill")

	love.graphics.pop()
	love.graphics.setColor(GDefaultColor)
end

function ResourceCoin:die()
	self.dead = true
	self.area:addGameObject("InfoText", self.x, self.y, {
		text = ("+" .. self.power.abbreviation),
		color = self.power.color,
		scaleFactor = SX
	})
	self.area:addGameObject("BoostCoinEffect", self.x, self.y, { color = self.power.color, w = self.w, h = self.h })

	for i = 1, love.math.random(4, 8) do
		self.area:addGameObject("ExplodeParticle", self.x, self.y, { s = 3, color = self.power.color })
	end
end

function ResourceCoin:destroy()
	ResourceCoin.super.destroy(self)
end
