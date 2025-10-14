Player = GameObject:extend()
function Player:new(area, x, y, opts)
	Player.super.new(self, area, x, y, opts)
	self.x, self.y = x, y
	self.w, self.h = 12, 12
	self.projectileManager = ProjectileManager(self)

	-- PHYSICS
	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
	self.collider:setObject(self)
	self.collider:setCollisionClass("Player")
	self.collider:setType("static")

	-- MOVEMENT
	self.rotation = math.pi / 2 -- look down
	self.xvel = 0
	self.yvel = 0


	self.shoot_cooldown_timer = 0
	self.acceleration = 1000
	self.baseMaxVelocity = 100
	self.maxVelocity = self.baseMaxVelocity
	self.friction = 10

	self.boosting = false
	self.trailColor = GSkillPointColor
	self.rotationVelocity = 1.66 * math.pi
	self.isBounce = false

	-- HP
	self.hp = 100
	self.max_hp = 100

	--BOOST ABILTY
	self.boost = 1
	self.maxBoost = 1

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
	self.chance = PlayerChanceManager(self, self.projectileManager)
	self.multiplierManager = MultiplierManager(self)

	self.chance:generateChances()
	self.multiplierManager:generateChanceMultiplier()

	self:setAttack("Hearth")
	self.timer:every(0.01, function()
		self.area:addGameObject(
			"TrailParticle",
			self.x - self.w * math.cos(self.rotation),
			self.y - self.h * math.sin(self.rotation),
			{
				parent = self,
				radius = math.customRandom(2, 4),
				duration = math.customRandom(0.15, 0.25),
				color = self
					.trailColor
			}
		)
	end)


	self.timer:every(5, function()
		self:tick()
	end)

	--[[
		correct this one
	]]
	-- self.timer:after(1, function()
	-- 	self.chance:onShieldProjectileChance()
	-- end)
end

function Player:setStats()
	-- multiply the max hp by the multiplier
	self.max_hp = self.max_hp + self.flat_hp
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
	if GInput:down("right") then
		self.xvel = self.xvel + self.acceleration * dt
	end
	if GInput:down("left") then
		self.xvel = self.xvel - self.acceleration * dt
	end
	if GInput:down("down") then
		self.yvel = self.yvel + self.acceleration * dt
	end
	if GInput:down("up") then
		self.yvel = self.yvel - self.acceleration * dt
	end
	if GInput:pressed("boosting") then
		-- turbo nigga
		self.boosting = not self.boosting

		if self.boosting then
			self.chance.luckMultiplier = self.chance.luckMultiplier * 2
		else
			self.chance.luckMultiplier = self.chance.luckMultiplier / 2
		end

		self.maxVelocity = self.boosting and 2 * self.baseMaxVelocity or self.baseMaxVelocity
	end

	local targetAngle = self.rotation

	--[[
	TODO : fix this issues with the rotation
	]]

	--Check diagonal movements first (they require two keys)
	if GInput:down("shootup") and GInput:down("shootright") then
		targetAngle = -math.pi / 4 -- 45 degrees up-right
	elseif GInput:down("shootup") and GInput:down("shootleft") then
		targetAngle = -3 * math.pi / 4 -- 135 degrees up-left
	elseif GInput:down("shootdown") and GInput:down("shootright") then
		targetAngle = math.pi / 4 -- 45 degrees down-right
	elseif GInput:down("shootdown") and GInput:down("shootleft") then
		targetAngle = 3 * math.pi / 4 -- 135 degrees down-left

		-- Then check single key movements
	elseif GInput:down("shootright") then
		targetAngle = 0      -- 0 degrees (facing right)
	elseif GInput:down("shootleft") then
		targetAngle = math.pi -- 180 degrees (facing left)
	elseif GInput:down("shootdown") then
		targetAngle = math.pi / 2 -- 90 degrees (facing down)
	elseif GInput:down("shootup") then
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

		GCamera:shake(6, 60, 0.2)
		flash(3)
		Slow(0.25, 0.5)
	else
		GCamera:shake(3, 60, 0.1)
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
			self.multiplierManager:onAmmoPickupChance()
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
	self.projectileManager:update(dt)
end

function Player:draw()
	love.graphics.print("ammo : " .. self.ammo, self.x + 50, self.y - 50)
	love.graphics.print("hp : " .. self.hp, self.x + 50, self.y - 70)
	love.graphics.print("attack : " .. self.attack, self.x + 50, self.y - 90)
	love.graphics.print("damage :" .. self.projectileManager.damage, self.x + 50, self.y - 110)
	love.graphics.print("tears :" .. self.projectileManager.tearIterator, self.x + 50, self.y - 130)
	love.graphics.print("shootAngle : " .. self.projectileManager.shootAngle, self.x + 50, self.y - 150)
	local velocity = math.sqrt(self.xvel ^ 2 + self.yvel ^ 2)
	love.graphics.print("velocity : " .. velocity, self.x + 50, self.y - 170)
	love.graphics.print("luck : " .. self.chance.luckMultiplier, self.x + 50, self.y - 190)

	love.graphics.print("static velocity : " .. self.baseMaxVelocity, self.x + 50, self.y - 210)
	love.graphics.print("static friction : " .. self.friction, self.x + 50, self.y - 230)


	love.graphics.setColor(Attacks[self.attack].color)
	GDraft:circle(self.x, self.y, self.w + 5, nil, "fill")

	love.graphics.setColor(GDefaultColor)
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
	GRoom.current_room.score = GRoom.current_room.score + amount
end

function Player:shoot()
	local distance = 1.2 * self.w
	self.area:addGameObject(
		"ShootEffect",
		self.x + distance * math.cos(self.rotation),
		self.y + distance * math.sin(self.rotation),
		{ player = self, distance = distance, attack = self.attack } -- {self.attack.color[1],self.attack.color[2],self.attack.color[3],self.attack.color[4]}
	)

	self.projectileManager:shoot(distance)
	self:addAmmo(-Attacks[self.attack].ammo)
end

function Player:setAttack(attack)
	self.attack = attack
	self.shoot_cooldown = Attacks[attack].cooldown - self.shoot_cooldown * self.shoot_cooldown_timer
	self.projectileManager:updateAttack(attack)
end

function Player:die()
	self.dead = true
	flash(4)
	GCamera:shake(6, 60, 0.4)


	self.projectileManager = nil
	self.chance = nil
	self.multiplierManager = nil
	self.ASPDMultiplier = nil

	Slow(0.15, 1)
	for i = 1, love.math.random(8, 12) do
		self.area:addGameObject("ExplodeParticle", self.x, self.y, { color = GHPColor })
	end
end
