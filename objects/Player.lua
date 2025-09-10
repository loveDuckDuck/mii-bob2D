Player = GameObject:extend()
function Player:new(area, x, y, opts)
	Player.super.new(self, area, x, y, opts)
	self.x, self.y = x, y
	self.w, self.h = 12, 12
	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
	self.collider:setObject(self)
	self.collider:setCollisionClass("Player")
	self.rotation = math.pi / 2 -- look down
	self.rotationVelocity = 1.66 * math.pi
	self.xvel = 0
	self.yvel = 0
	self.velocity = 0
	self.maxVelocity = 100
	self.baseMaxVelocity = 100

	self.acceleration = 100
	self.enabledToShoot = false

	self.speed = 500

	self.maxVelocity = self.baseMaxVelocity
	self.boosting = false
	self.trailColor = G_skill_point_color

	self.maxAmmo = 100
	self.ammo = self.maxAmmo

	self.shoot_timer = 0
	self.shoot_cooldown = 0.24

	self:setAttack("Rapid")

	self.timer:every(0.01, function()
		self.area:addGameObject(
			"TrailParticle",
			self.x - self.w * math.cos(self.rotation),
			self.y - self.h * math.sin(self.rotation),
			{ parent = self, radius = GlobalRandom(2, 4), duration = GlobalRandom(0.15, 0.25), color = self.trailColor }
		)
	end)

	self.friction = 5

	self.isBounce = false

	InputHandler:bind("f4", function()
		self:die()
	end)

	self.timer:every(5, function()
		self:tick()
	end)
end

function Player:physics(dt)
	self.xvel = self.xvel * (1 - math.min(dt * self.friction, 1))
	self.yvel = self.yvel * (1 - math.min(dt * self.friction, 1))

	-- Clamp velocities to max velocity
	local speed = math.sqrt(self.xvel ^ 2 + self.yvel ^ 2)
	if speed > self.maxVelocity then
		self.xvel = (self.xvel / speed) * self.maxVelocity
		self.yvel = (self.yvel / speed) * self.maxVelocity
	end

	self.x = self.x + self.xvel * dt
	self.y = self.y + self.yvel * dt

	self.collider:setPosition(self.x, self.y)
end

function Player:move(dt)
	if InputHandler:down("d") and self.xvel < self.speed then
		self.xvel = self.xvel + self.speed * dt
	end
	if InputHandler:down("a") and self.xvel > -self.speed then
		self.xvel = self.xvel - self.speed * dt
	end
	if InputHandler:down("s") and self.yvel < self.speed then
		self.yvel = self.yvel + self.speed * dt
	end
	if InputHandler:down("w") and self.yvel > -self.speed then
		self.yvel = self.yvel - self.speed * dt
	end

	if InputHandler:down("b") then
		Slow(0.15, 1)
	end

	if InputHandler:down("boosting") then
		-- turbo nigga
		self.isBounce = not self.isBounce
		self.maxVelocity = self.boosting and 1.5 * self.baseMaxVelocity or 0.5 * self.baseMaxVelocity
		self.boosting = not self.boosting
	end

	--[[
        love2D reference
        up 270 / -90
        right == 0
        180 left
        down 90
    ]]

	local targetAngle = self.rotation

	--Check diagonal movements first (they require two keys)
	if love.keyboard.isDown("up") and love.keyboard.isDown("right") then
		targetAngle = -math.pi / 4 -- 45 degrees up-right
	elseif love.keyboard.isDown("up") and love.keyboard.isDown("left") then
		targetAngle = -3 * math.pi / 4 -- 135 degrees up-left
	elseif love.keyboard.isDown("down") and love.keyboard.isDown("right") then
		targetAngle = math.pi / 4 -- 45 degrees down-right
	elseif love.keyboard.isDown("down") and love.keyboard.isDown("left") then
		targetAngle = 3 * math.pi / 4 -- 135 degrees down-left

		-- Then check single key movements
	elseif love.keyboard.isDown("right") then
		targetAngle = 0 -- 0 degrees (facing right)
	elseif love.keyboard.isDown("left") then
		targetAngle = math.pi -- 180 degrees (facing left)
	elseif love.keyboard.isDown("down") then
		targetAngle = math.pi / 2 -- 90 degrees (facing down)
	elseif love.keyboard.isDown("up") then
		targetAngle = -math.pi / 2 -- -90 degrees (facing up)
	end
	--[[
    else
        -- Default rotation when no keys are pressed
        targetAngle = math.pi / 2 -- Or whatever default you want
    end
    ]]

	if love.keyboard.isDown("up", "down", "right", "left") then
		self.enabledToShoot = true
	else
		self.enabledToShoot = false
		self.shoot_timer = 0
	end

	if self.enabledToShoot then
		self.shoot_timer = self.shoot_timer + dt
		if self.shoot_timer > self.shoot_cooldown then
			self.shoot_timer = 0
			self:shoot()
		end
	end

	RotateTowards(self, targetAngle, dt)
end

function Player:checkCollision(dt)
	if self.collider:enter("Collectable") then
		local collision_data = self.collider:getEnterCollisionData("Collectable")
		local object = collision_data.collider:getObject()
		if object:is(Ammo) then
			self:addAmmo(object.cointValue)
			object:die()
		elseif object:is(BoostCoin) then
			object:die()
		elseif object:is(ResourceCoin) then
			self.attack = object.power.name
			self:setAttack(self.attack)
			print("self.attack", self.attack)
			object:die()
		end
	end
end

function Player:update(dt)
	Player.super.update(self, dt)
	self:physics(dt)
	self:checkCollision(dt)
	self:move(dt)
end

function Player:draw()
	love.graphics.print("ammo : " .. self.ammo, self.x + 50, self.y - 50)
end

function Player:tick()
	self.area:addGameObject("TickEffect", self.x, self.y, { parent = self })
end

function Player:addAmmo(amount)
	self.ammo = self.ammo + amount
	if self.ammo < 0 then
		self.ammo = 0
	end
end

function Player:shoot()
	local distance = 1.2 * self.w
	self.area:addGameObject(
		"ShootEffect",
		self.x + distance * math.cos(self.rotation),
		self.y + distance * math.sin(self.rotation),
		{ player = self, distance = distance, attack = self.attack } -- {self.attack.color[1],self.attack.color[2],self.attack.color[3],self.attack.color[4]}
	)

	if self.ammo == 0 then
		self:setAttack("Neutral")
	end

	if self.attack == "Neutral" then
		self.area:addGameObject(
			"Projectile",
			self.x + 1.5 * distance * math.cos(self.rotation),
			self.y + 1.5 * distance * math.sin(self.rotation),
			{ rotation = self.rotation, isBounce = self.isBounce, parent = self, attack = self.attack }
		)
	elseif self.attack == "Double" then
		self.area:addGameObject(
			"Projectile",
			self.x + 1.5 * distance * math.cos(self.rotation + math.pi / 12),
			self.y + 1.5 * distance * math.sin(self.rotation + math.pi / 12),
			{ rotation = self.rotation, isBounce = self.isBounce, parent = self, attack = self.attack }
		)
		self.area:addGameObject(
			"Projectile",
			self.x + 1.5 * distance * math.cos(self.rotation - math.pi / 12),
			self.y + 1.5 * distance * math.sin(self.rotation - math.pi / 12),
			{ rotation = self.rotation, isBounce = self.isBounce, parent = self, attack = self.attack }
		)
	elseif self.attack == "Triple" then
		self.area:addGameObject(
			"Projectile",
			self.x + 1.5 * distance * math.cos(self.rotation + math.pi / 4),
			self.y + 1.5 * distance * math.sin(self.rotation + math.pi / 4),
			{ rotation = self.rotation, isBounce = self.isBounce, parent = self, attack = self.attack }
		)
		self.area:addGameObject(
			"Projectile",
			self.x + 1.5 * distance * math.cos(self.rotation),
			self.y + 1.5 * distance * math.sin(self.rotation),
			{ rotation = self.rotation, isBounce = self.isBounce, parent = self, attack = self.attack }
		)

		self.area:addGameObject(
			"Projectile",
			self.x + 1.5 * distance * math.cos(self.rotation - math.pi / 4),
			self.y + 1.5 * distance * math.sin(self.rotation - math.pi / 4),
			{ rotation = self.rotation, isBounce = self.isBounce, parent = self, attack = self.attack }
		)
	elseif self.attack == "Rapid" then
		self.area:addGameObject(
			"Projectile",
			self.x + 1.5 * distance * math.cos(self.rotation),
			self.y + 1.5 * distance * math.sin(self.rotation),
			{ rotation = self.rotation, isBounce = self.isBounce, parent = self, attack = self.attack }
		)
	end
	self:addAmmo(-Attacks[self.attack].ammo)
end

function Player:setAttack(attack)
	self.attack = attack
	
	self.shoot_cooldown = Attacks[attack].cooldown
end

function Player:die()
	self.dead = true
	flash(4)
	GlobalCamera:shake(6, 60, 0.4)

	Slow(0.15, 1)
	for i = 1, love.math.random(8, 12) do
		self.area:addGameObject("ExplodeParticle", self.x, self.y, { color = G_hp_color })
	end
end
