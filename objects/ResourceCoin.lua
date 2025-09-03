ResourceCoin = CoinObject:extend()

function ResourceCoin:new(area, x, y, opts)
	ResourceCoin.super.new(self, area, x, y, opts)
	self.power = table.randomResource(Attacks)
end
function ResourceCoin:updata(dt)
	ResourceCoin.super.updata(self, dt)
end

function ResourceCoin:draw()
	love.graphics.setColor(self.power.color)
	PushRotate(self.x, self.y, self.collider:getAngle())
	self.power.resource(self.x, self.y, self.w, self.h)
	love.graphics.pop()
	love.graphics.setColor(G_default_color)
end
function ResourceCoin:die()
	self.dead = true
	self.area:addGameObject("InfoText", self.x, self.y, { text = ("+" .. self.power.abbreviation), color = self.power.color })
	self.area:addGameObject("BoostCoinEffect", self.x, self.y, { color = self.power.color, w = self.w, h = self.h })
	--[[
        XXX: fix this using the attack value and add values to that 
    ]]
	for i = 1, love.math.random(4, 8) do
		self.area:addGameObject("ExplodeParticle", self.x, self.y, { s = 3, color = self.power.color })
	end
end
