BoostCoin = CoinObject:extend()

function BoostCoin:new(area, x, y, opts)
	BoostCoin.super.new(self, area, x, y, opts)
	self.w, self.h = 12, 12
end

function BoostCoin:update(dt)
	BoostCoin.super.update(self, dt)
end

function BoostCoin:draw()
	love.graphics.setColor(G_boost_color)
	PushRotate(self.x, self.y, self.collider:getAngle())
	GDraft:rhombus(self.x, self.y, 1.5 * self.w, 1.5 * self.h, "line")
	GDraft:rhombus(self.x, self.y, 0.5 * self.w, 0.5 * self.h, "fill")
	love.graphics.pop()
	love.graphics.setColor(G_default_color)
end

function BoostCoin:die()
	self.dead = true
	self.area:addGameObject("InfoText", self.x, self.y, { text = "+BOOST", color = G_boost_color })
end
