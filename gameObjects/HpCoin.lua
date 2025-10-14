HpCoin = StatCoin:extend()

function HpCoin:new(area, x, y, opts)
	HpCoin.super.new(self, area, x, y, opts)
end

function HpCoin:update(dt)
	HpCoin.super.update(self, dt)

end

function HpCoin:draw()
	love.graphics.setColor(GBoostColor)
	PushRotate(self.x, self.y, self.collider:getAngle())
	love.graphics.setColor(GWhiteCream)
	GDraft:rhombus(self.x, self.y, 1.5 * self.w, 1.5 * self.h, "line")
	love.graphics.setColor(GBoostColor)
	GDraft:rhombus(self.x, self.y, 1.5 * self.w, 3 * self.h, "line")

	love.graphics.pop()
	love.graphics.setColor(GDefaultColor)
end

function HpCoin:die()
	self.dead = true
	for i = 1, love.math.random(4, 8) do
		self.area:addGameObject("ExplodeParticle", self.x, self.y, { s = 3, color = GAmmoColor })
	end
	self.area:addGameObject("InfoText", self.x, self.y, { text = "+HP ?!!!", color =  math.threeRamdon() })
end
