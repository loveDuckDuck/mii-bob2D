CoinObject = GameObject:extend()

function CoinObject:new(area, x, y, opts)
	CoinObject.super.new(self, area, x, y, opts)

	self.w, self.h = 8, 8
	self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.w, self.h)
	self.collider:setObject(self)
	self.collider:setCollisionClass("Collectable")

	self.collider:setFixedRotation(false)
	self.rotation = math.customRandom(0, 2 * math.pi)
	self.velocity = math.customRandom(10, 20)
	self.collider:setLinearVelocity(self.velocity * math.cos(self.rotation), self.velocity * math.sin(self.rotation))
	self.collider:applyAngularImpulse(math.customRandom(-24, 24))
	self.cointValue = 5
end

function CoinObject:update(dt)
	CoinObject.super.update(self, dt)
	local target = GlobalRoomController.current_room.player
	if target then
		local projectileHeading = Vector.new(self.collider:getLinearVelocity()):normalized()
		local dy = target.y - self.y
		local dx = target.x - self.x

		local angle = GlobalAtan2(dy, dx)
		local toTargetHeading = Vector.new(math.cos(angle), math.sin(angle)):normalized()
		local finalHeading = (projectileHeading + 0.1 * toTargetHeading):normalized()
		self.collider:setLinearVelocity(self.velocity * finalHeading.x, self.velocity * finalHeading.y)
	else
		self.collider:setLinearVelocity(
			self.velocity * math.cos(self.rotation),
			self.velocity * math.sin(self.rotation)
		)
	end
end

