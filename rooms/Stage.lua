Stage = Object:extend()

function Stage:new()
	self.area = Area(self)

	self.area:addPhysicsWorld()
	self.area.world:addCollisionClass("Player")

	self.area.world:addCollisionClass("Projectile", { ignores = { "Player" } }) -- the world need to check

	self.area.world:addCollisionClass("Collectable", { ignores = { "Player", "Projectile" } })
	self.area.world:addCollisionClass("Enemy") --{ ignores = { "Enemy", "Collectable" } }

	self.area.world:addCollisionClass("EnemyProjectile", { ignores = { "EnemyProjectile", "Projectile", "Enemy" } })
	self.area.world:addCollisionClass("Barrier", { ignores = { "Player", "Projectile", "Collectable" } }) -- the world need to check

	self.main_canvas = love.graphics.newCanvas(GW, GH)
	self.rgbShiftCanvas = love.graphics.newCanvas(GW, GH)

	self.rgb_shift = love.graphics.newShader('resource/shaders/rgbShift.frag')
	self.rgb_shift_mag = 2.5
	-- self.tvShader = love.graphics.newShader('resource/shaders/tvShader.frag')
	-- self.tvCanvas = love.graphics.newCanvas(GW, GH)

	self.amberShader = love.graphics.newShader('resource/shaders/amber.frag')
	self.crtShader = love.graphics.newShader('resource/shaders/crtShader.frag')

	self.final_canvas = love.graphics.newCanvas(GW, GH)
	self.player = self.area:addGameObject("Player", GW / 2, GH / 2)

	self.director = Director(self, self.player)

	self.score = 0
	self.goalScore = 30
	self.font = GFont
	self.counterAttack = 0
	self.starGameInfo = self.area:addGameObject("StartGameInfo", 0, 0)

	GCamera.smoother = Camera.smooth.damped(100)


	GInput:bind("mouse1", function()
		self.counterAttack = self.counterAttack + 1

		if self.counterAttack > Lenght(Attacks) then
			self.counterAttack = 1
		end

		self.player:setAttack(table.keys(Attacks)[self.counterAttack])
	end)
	GInput:bind("mouse2", function()
		self.counterAttack = self.counterAttack - 1

		if self.counterAttack < 1 then
			self.counterAttack = Lenght(Attacks)
		end

		self.player:setAttack(table.keys(Attacks)[self.counterAttack])
	end)
	self.time = 0
end

function Stage:update(dt)
	GCamera:lockPosition(dt, GW / 2, GH / 2)
	GCamera:update(dt)
	self.time = self.time + dt
	if self.player then
		self.director:update(dt)

		self.area:update(dt)
	end

	if (not self.player) then
		self:destroy()
	end
end

function Stage:activate()
	print("Stage Active")
end

function Stage:deactivate()
	print("Stage deactivate")
end

function Stage:numbers()
	-- Score
	love.graphics.setColor(GDefaultColor)
	love.graphics.print(
		self.score,
		GW - 20,
		10,
		0,
		1,
		1,
		math.floor(self.font:getWidth(self.score) / 2),
		self.font:getHeight() / 2
	)
	-- Stats player
	love.graphics.print("hp : " .. self.player.hp, 0, 70)
	love.graphics.print("attack : " .. self.player.attack, 0, 90)
	love.graphics.print("damage :" .. self.player.projectileManager.damage, 0, 110)
	love.graphics.print("tears :" .. self.player.projectileManager.tearIterator, 0, 130)
	love.graphics.print("shootAngle : " .. self.player.projectileManager.shootAngle, 0, 150)
	local velocity = math.floor(math.sqrt(self.player.xvel ^ 2 + self.player.yvel ^ 2))
	love.graphics.print("velocity : " .. velocity, 0, 170)
	love.graphics.print("luck : " .. self.player.changeManager.luckMultiplier, 0, 190)
	love.graphics.print("static velocity : " .. self.player.baseMaxVelocity, 0, 210)
	love.graphics.print("static friction : " .. self.player.friction, 0, 230)




	-- HP
	local r, g, b = unpack(GHPColor)
	local hp, max_hp = self.player.hp, self.player.max_hp
	love.graphics.setColor(r, g, b)
	love.graphics.rectangle("fill", GW / 2 - 52, GH - 16, 156 * (hp / max_hp), 7)
	love.graphics.setColor(r - 32 / 255, g - 32 / 255, b - 32 / 255)
	love.graphics.rectangle("line", GW / 2 - 52, GH - 16, 156, 7)
end

function Stage:draw()
	if not self.player then
		return
	end

	love.graphics.setCanvas(self.rgbShiftCanvas)
	love.graphics.clear()
	GCamera:attach(0, 0, GW, GH)
	self.area:drawOnly({ 'rgb_shift' })
	GCamera:detach()
	love.graphics.setCanvas()




	love.graphics.setCanvas(self.main_canvas)
	love.graphics.clear()
	GCamera:attach(0, 0, GW, GH)
	self.area:drawExcept({ 'rgb_shift' })
	GCamera:detach()
	love.graphics.setCanvas()

	love.graphics.setCanvas(self.final_canvas)
	love.graphics.clear()
	love.graphics.setColor(1, 1, 1)
	love.graphics.setBlendMode("alpha", "premultiplied")

	self.rgb_shift:send('amount', {
		math.customRandom(-self.rgb_shift_mag, self.rgb_shift_mag) / GW,
		math.customRandom(-self.rgb_shift_mag, self.rgb_shift_mag) / GH
	})

	love.graphics.setShader(self.rgb_shift)
	love.graphics.draw(self.rgbShiftCanvas, 0, 0, 0, 1, 1)
	love.graphics.setShader()



	love.graphics.draw(self.main_canvas, 0, 0, 0, 1, 1)
	love.graphics.setBlendMode("alpha")
	love.graphics.setCanvas()


	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setBlendMode('alpha', 'premultiplied')
	local x = (love.graphics.getWidth() - GW * SX) / 2
	local y = (love.graphics.getHeight() - GH * SY) / 2

	love.graphics.setShader(self.crtShader)
	self.crtShader:send('iResolution', { love.graphics.getWidth(), love.graphics.getHeight() })
	self.crtShader:send('iTime',self.time * 10)
	love.graphics.draw(self.final_canvas, x, y, 0, SX, SY)
	love.graphics.setShader()

	love.graphics.setBlendMode('alpha')
end

function Stage:destroy()
	self.director:destroy()
	self.area:destroy()
	self.area = nil
	self.player = nil

end

function Stage:finish()
	GTimer:after(1, function()
		GRoom:gotoRoom('Stage', UUID())

		if not Achievements['10K Fighter'] then
			Achievements['10k Fighter'] = true
			-- Do whatever else that should be done when an achievement is unlocked
		end
	end)
end
