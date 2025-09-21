Player = GameObject:extend()
function Player:new(area, x, y, opts)
	Player.super.new(self, area, x, y, opts)
	self.x, self.y = x, y
	self.w, self.h = 12, 12
	self.ProjectileManager = ProjectileManager(self)

	-- PHYSICS
	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
	self.collider:setObject(self)
	self.collider:setCollisionClass("Player")
	self.collider:setType("static")

	-- MOVEMENT
	self.rotation = math.pi / 2 -- look down
	self.xvel = 0
	self.yvel = 0

	self.acceleration = 1000
	self.baseMaxVelocity = 100
	self.maxVelocity = self.baseMaxVelocity
	self.friction = 10

	self.boosting = false
	self.trailColor = G_skill_point_color
	self.rotationVelocity = 1.66 * math.pi
	self.isBounce = false

	-- HP
	self.hp = 100
	self.max_hp = 100

	--BOOST ABILTY
	self.boost = 1
	self.maxBoost = 1

	-- MULTIPLIER HP
	self.hp_multiplier = 1
	-- FLATS HP
	self.flat_hp = 0
	-- AMMO
	self.maxAmmo = 100
	self.ammo = self.maxAmmo
	-- MULTIPLIER AMMO
	self.hp_ammo = 1
	-- FLATS AMMO
	self.flat_ammo = 0
	self.ammo_gain = 0

	-- SHOOTING
	self.shoot_timer = 0
	self.shoot_cooldown = 0.24
	self.enabledToShoot = false
	self.freakShot = false

	-- CYCLE
	self.cycle_timer = 0
	self.cycle_cooldown = 5

	-- ASPD
	self.baseASPDMultiplier = 1
	self.ASPDMultiplier = Stat(1)
	self.ASPDBoosting = 1
	self.additionalASPDMultiplier = {}

	-- HASTE AREA
	self.insideHasteArea = false
	self.preHasteASPDMultiplier = nil

	-- treeToPlayer(self)
	self:setStats()
	-- CHANCES

	-- GENERATE CHANCES
	self.chance = PlayerChanceManager(self)
	self.chance:generateChances()
	self:setAttack("Neutral")
	self.timer:every(0.01, function()
		self.area:addGameObject(
			"TrailParticle",
			self.x - self.w * math.cos(self.rotation),
			self.y - self.h * math.sin(self.rotation),
			{ parent = self, radius = GlobalRandom(2, 4), duration = GlobalRandom(0.15, 0.25), color = self.trailColor }
		)
	end)

	InputHandler:bind("f4", function()
		self:die()
	end)

	self.timer:every(5, function()
		self:tick()
	end)
	self.timer:after(5, function()
		print("FREAK ASS")
		self.chance:onFreakProjectileDirection()
	end)
end

function Player:setStats()
	-- multiply the max hp by the multiplier
	self.max_hp = (self.max_hp + self.flat_hp) * self.hp_multiplier
	self.hp = self.max_hp
	-- multiply the max ammo by the multiplier
	self.maxAmmo = (self.maxAmmo + self.flat_ammo) * self.hp_ammo
	self.ammo = self.maxAmmo
end

function Player:physics(dt)
	self.xvel = self.xvel * (1 - math.min(dt * self.friction, 1))
	self.yvel = self.yvel * (1 - math.min(dt * self.friction, 1))

	-- Clamp velocities to max velocity
	local velocity = math.sqrt(self.xvel ^ 2 + self.yvel ^ 2)

	if velocity > self.maxVelocity then
		self.xvel = (self.xvel / velocity) * self.maxVelocity
		self.yvel = (self.yvel / velocity) * self.maxVelocity
	end

	self.x = self.x + self.xvel * dt
	self.y = self.y + self.yvel * dt

	self.collider:setPosition(self.x, self.y)
end

function Player:move(dt)
	if InputHandler:down("d") then
		self.xvel = self.xvel + self.acceleration * dt
	end
	if InputHandler:down("a") then
		self.xvel = self.xvel - self.acceleration * dt
	end
	if InputHandler:down("s") then
		self.yvel = self.yvel + self.acceleration * dt
	end
	if InputHandler:down("w") then
		self.yvel = self.yvel - self.acceleration * dt
	end

	if InputHandler:down("b") then
		Slow(0.15, 1)
	end

	if InputHandler:pressed("boosting") then
		-- turbo nigga
		self.boosting = not self.boosting

		self.maxVelocity = self.boosting and 2 * self.baseMaxVelocity or self.baseMaxVelocity
	end

	if self.boosting then
		self.chance.luckMultiplier = 2
	else
		self.chance.luckMultiplier = 1
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
		if self.shoot_timer > self.shoot_cooldown / self.ASPDMultiplier.value then
			self.shoot_timer = 0
			self:shoot()
		end
	end

	RotateTowards(self, targetAngle, dt)
end

function Player:removeHP(amount)
	self.hp = self.hp - (amount or 5)
	if self.hp <= 0 then
		self.hp = 0
		self:die()
	end
end

function Player:hit(damage)
	if self.invincible then
		return
	end
	damage = damage or 10

	for i = 1, love.math.random(4, 8) do
		self.area:addGameObject("ExplodeParticle", self.x, self.y)
	end
	self:removeHP(damage)

	if damage >= 30 then
		self.invincible = true
		self.timer:after("invincibility", 2, function()
			self.invincible = false
		end)
		for i = 1, 50 do
			self.timer:after((i - 1) * 0.04, function()
				self.invisible = not self.invisible
			end)
		end
		self.timer:after(51 * 0.04, function()
			self.invisible = false
		end)

		GlobalCamera:shake(6, 60, 0.2)
		flash(3)
		Slow(0.25, 0.5)
	else
		GlobalCamera:shake(3, 60, 0.1)
		flash(2)
		Slow(0.75, 0.25)
	end
end

function Player:checkCollision(dt)
	if self.collider:enter("Collectable") then
		local collision_data = self.collider:getEnterCollisionData("Collectable")
		local object = collision_data.collider:getObject()
		if object:is(Ammo) then
			self:addAmmo(object.cointValue)
			self:addScore(object.cointValue * 10)
			self.chance:onAmmoPickupChance()
			object:die()
		elseif object:is(BoostCoin) then
			object:die()
			self.chance:onBoostPickupChange()
		elseif object:is(ResourceCoin) then
			self.attack = object.power.name
			self:setAttack(self.attack)
			object:die()
		elseif object:is(HpCoin) then
			self.chance:onGainSomeHp()
			object:die()
		end
	end
	if self.collider:enter("Enemy") then
		local collision_data = self.collider:getEnterCollisionData("Enemy")
		local object = collision_data.collider:getObject()
		if object:is(Rock) then
			self:hit(30)
		end
	end
end

function Player:updateASPDMultiplier(dt)
	self.additionalASPDMultiplier = {}
	if self.insideHasteArea then
		self.ASPDMultiplier:increase(100)
	end
	if self.ASPDBoosting then
		self.ASPDMultiplier:increase(100)
	end
	self.ASPDMultiplier:update(dt)
end

function Player:update(dt)
	Player.super.update(self, dt)
	self:physics(dt)
	self:move(dt)
	self:checkCollision(dt)
	self:updateASPDMultiplier(dt)
	self.ProjectileManager:update(dt)
end

function Player:draw()
	love.graphics.print("ammo : " .. self.ammo, self.x + 50, self.y - 50)
	love.graphics.print("hp : " .. self.hp, self.x + 50, self.y - 70)
	love.graphics.print("attack : " .. self.attack, self.x + 50, self.y - 90)
	love.graphics.print("damage :" .. self.ProjectileManager.damage, self.x + 50, self.y - 110)
	love.graphics.print("tears :" .. self.ProjectileManager.tearIterator, self.x + 50, self.y - 130)
	love.graphics.print("shootAngle : " .. self.ProjectileManager.shootAngle, self.x + 50, self.y - 150)
	local velocity = math.sqrt(self.xvel ^ 2 + self.yvel ^ 2)
	love.graphics.print("velocity : " .. velocity, self.x + 50, self.y - 170)
	love.graphics.print("luck : " .. self.chance.luckMultiplier, self.x + 50, self.y - 190)
end

function Player:tick()
	self.area:addGameObject("TickEffect", self.x, self.y, { parent = self })
end

function Player:addAmmo(amount)
	self.ammo = self.ammo + amount + self.ammo_gain
	if self.ammo < 0 then
		self.ammo = 0
	end
end

function Player:addScore(amount)
	GlobalRoomController.current_room.score = GlobalRoomController:getCurrentRoom().score + amount
end

function Player:shoot()
	local distance = 1.2 * self.w
	self.area:addGameObject(
		"ShootEffect",
		self.x + distance * math.cos(self.rotation),
		self.y + distance * math.sin(self.rotation),
		{ player = self, distance = distance, attack = self.attack } -- {self.attack.color[1],self.attack.color[2],self.attack.color[3],self.attack.color[4]}
	)

	ProjectileManager.shoot(self.ProjectileManager, distance)
	self:addAmmo(-Attacks[self.attack].ammo)
end

function Player:setAttack(attack)
	self.attack = attack
	self.shoot_cooldown = Attacks[attack].cooldown
	self.ProjectileManager:updateAttack(attack)
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
