Ammo = GameObject:extend()

function Ammo:new(area, x, y, opts)
	Ammo.super.new(self, area, x, y, opts)

	self.w, self.h = 8, 8
	self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.w, self.h)
	self.collider:setObject(self)
	self.collider:setCollisionClass("Collectable")

	self.collider:setFixedRotation(false)
	self.rotation = GlobalRandom(0, 2 * math.pi)
	self.velocity = GlobalRandom(10, 20)
	self.collider:setLinearVelocity(self.velocity * math.cos(self.rotation), self.velocity * math.sin(self.rotation))
	self.collider:applyAngularImpulse(GlobalRandom(-24, 24))
end

function Ammo:update(dt)
	Ammo.super.update(self, dt)
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

function Ammo:draw()
	love.graphics.setColor(G_ammo_color)
	PushRotate(self.x, self.y, self.collider:getAngle())
	DraftDrawer:rhombus(self.x, self.y, self.w, self.h, "line")
	love.graphics.pop()
	love.graphics.setColor(G_default_color)
end

function Ammo:die()
    self.dead = true
    self.area:addGameObject('AmmoEffect', self.x, self.y, 
    {color = G_ammo_color, w = self.w, h = self.h})
    for i = 1, love.math.random(4, 8) do 
    	self.area:addGameObject('ExplodeParticle', self.x, self.y, {s = 3, color = G_ammo_color}) 
    end
end