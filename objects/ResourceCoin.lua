-- No cmd() found.
ResourceCoin = CoinObject:extend()

function ResourceCoin:new(area, x, y, opts)
	-- Super constructor call 🚀
	ResourceCoin.super.new(self, area, x, y, opts)
	-- Get random attack power ⚔️
	self.power = table.randomResource(Attacks)
end
function ResourceCoin:updata(dt)
	-- Update super class ⬆️
	ResourceCoin.super.updata(self, dt)
end

function ResourceCoin:draw()
	-- Set drawing color 🎨
	love.graphics.setColor(self.power.color)
	-- Push rotation matrix 🔄
	PushRotate(self.x, self.y, self.collider:getAngle())
	-- Draw resource graphic ✍️
	self.power.resource(self.x, self.y, self.w, self.h)
	-- Pop rotation matrix ↩️
	love.graphics.pop()
	-- Reset color to default 🔄
	love.graphics.setColor(G_default_color)
end
function ResourceCoin:die()
	-- Set object as dead 💀
	self.dead = true
	-- Add info text object ℹ️
	self.area:addGameObject("InfoText", self.x, self.y, { text = ("+" .. self.power.abbreviation), color = self.power.color })
	-- Add boost effect object ✨
	self.area:addGameObject("BoostCoinEffect", self.x, self.y, { color = self.power.color, w = self.w, h = self.h })
	--[[
        XXX: fix this using the attack value and add values to that 
    ]]
	-- Create explode particles 💥
	for i = 1, love.math.random(4, 8) do
		-- Add particle effect 💫
		self.area:addGameObject("ExplodeParticle", self.x, self.y, { s = 3, color = self.power.color })
	end
end