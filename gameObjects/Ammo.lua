Ammo = CoinObject:extend()

function Ammo:new(area, x, y, opts)
	Ammo.super.new(self, area, x, y, opts)
	self.cointValue = 5
end

function Ammo:update(dt)
	Ammo.super.update(self, dt)
end

function Ammo:draw()
	love.graphics.setColor(GAmmoColor)
	PushRotate(self.x, self.y, self.collider:getAngle())
	GDraft:rhombus(self.x, self.y, self.w, self.h, "line")
	love.graphics.pop()
	love.graphics.setColor(GDefaultColor)
end

function Ammo:die()
	self.dead = true
	self.area:addGameObject("InfoText", self.x, self.y, { text = ("+" .. self.cointValue), color =  math.threeRamdon() })
	self.area:addGameObject("AmmoEffect", self.x, self.y, { color = GAmmoColor, w = self.w, h = self.h })
	for i = 1, love.math.random(4, 8) do
		self.area:addGameObject("ExplodeParticle", self.x, self.y, { s = 3, color = GAmmoColor })
	end
end

function Ammo:destroy()
    Ammo.super.destroy(self)
end

