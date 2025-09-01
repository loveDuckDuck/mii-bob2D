BoostCoin = GameObject:extend()

function BoostCoin:new(area, x, y, opts)
	BoostCoin.super.new(self, area, x, y, opts)

	local direction = table.random({ -1, 1 })
	self.x = gw / 2 + direction * (gw / 2 + 48)
	self.y = GlobalRandom(48, gh - 48)

	self.w, self.h = 12, 12
	self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.w, self.h)
	self.collider:setObject(self)
	self.collider:setCollisionClass("Collectable")
	self.collider:setFixedRotation(false)
	self.velocity = -direction * GlobalRandom(20, 40)
	self.collider:setLinearVelocity(self.velocity, 0)
	self.collider:applyAngularImpulse(GlobalRandom(-24, 24))
end

function BoostCoin:update(dt)
	BoostCoin.super.update(self, dt)
	self.collider:setLinearVelocity(self.velocity, 0)
end

function BoostCoin:draw()
	love.graphics.setColor(G_boost_color)
	PushRotate(self.x, self.y, self.collider:getAngle())
	DraftDrawer:rhombus(self.x, self.y, 1.5 * self.w, 1.5 * self.h, "line")
	DraftDrawer:rhombus(self.x, self.y, 0.5 * self.w, 0.5 * self.h, "fill")
	love.graphics.pop()
	love.graphics.setColor(G_default_color)
end

function BoostCoin:die()
	self.area:addGameObject("InfoText", self.x, self.y, { text = "+BOOST", color = G_boost_color })
end
