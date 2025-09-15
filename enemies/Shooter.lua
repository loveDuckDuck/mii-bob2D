Shooter = Enemy:extend()

function Shooter:new(area, x, y, opts)
	Shooter.super.new(self, area, x, y, opts)
	self.name = "Shooter"
	self.target = GlobalRoomController.current_room.player

	-- coinvalues
	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w )
	self.collider:setPosition(self.x, self.y)
	self.collider:setObject(self)
	self.collider:setCollisionClass("Enemy")
	self.collider:setFixedRotation(true)

	self.offset = 5
	self.rotationLookingPlayer = 0
	self.rotation = GlobalRandom(0, 2 * math.pi)
	self.velocity = GlobalRandom(10, 20)
	self.collider:setLinearVelocity(self.velocity * math.cos(self.rotation), self.velocity * math.sin(self.rotation))
	self.collider:applyAngularImpulse(GlobalRandom(-100, 100))
	self.w, self.h = 10, 10

	self.timer:every(GlobalRandom(1, 3), function()
        local target_x, target_y = self.target.x, self.target.y
		self.area:addGameObject(
			"PreAttackEffect",
			target_x,
			target_y,
			{ shooter = self, color = G_hp_color, duration = 1.0, rotation = self.rotationLookingPlayer }
		)
		self.timer:after(0.5, function()
			self.area:addGameObject("EnemyProjectile", self.x, self.y, {

				rotation = self.rotationLookingPlayer,
				parent = self,
			})
		end)
	end)
end

function Shooter:update(dt)
	Shooter.super.update(self, dt)

	if self.target then
		local projectileHeading = Vector.new(self.collider:getLinearVelocity()):normalized()
		local dy = self.target.y - self.y
		local dx = self.target.x - self.x

		local angle = GlobalAtan2(dy, dx)
		self.rotationLookingPlayer = angle
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

function Shooter:draw()
	love.graphics.setColor(G_hp_color)
	PushRotate(self.x, self.y, self.rotationLookingPlayer)

	DraftDrawer:lozenge(self.x, self.y, self.w, "line")
	DraftDrawer:rhombus(self.x, self.y, self.w + self.offset, self.h + self.offset, "line")

	love.graphics.pop()

	love.graphics.setColor(G_default_color)
end

function Shooter:die()
	self.dead = true
	self.area:addGameObject("InfoText", self.x, self.y, { text = self.name, color = G_hp_color })
	self.area:addGameObject("EnemyDeathEffect", self.x, self.y, { color = G_hp_color, w = self.w, h = self.h })
	self.area:addGameObject("Ammo", self.x, self.y)
end
