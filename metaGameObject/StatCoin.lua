StatCoin = GameObject:extend()

function StatCoin:new(area, x, y, opts)
	StatCoin.super.new(self, area, x, y, opts)
	self.w, self.h = 12, 12
	local direction = table.random({ -1, 1 })
	self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.w, self.h)
	self.collider:setObject(self)
	self.collider:setCollisionClass("Collectable")
	self.collider:setFixedRotation(false)
	self.rotation = math.customRandom(0, 2 * math.pi)
	self.velocity = -direction * math.customRandom(20, 40)
	self.collider:setLinearVelocity(self.velocity, 0)
	self.collider:applyAngularImpulse(math.customRandom(-100, 100))
end

function StatCoin:update(dt)
	StatCoin.super.update(self, dt)
	if self.x < 0 or self.y < 0 or self.x > GW or self.y > GH then
		self:die()
	end
end


function StatCoin:destroy()
    StatCoin.super.destroy(self)
end
