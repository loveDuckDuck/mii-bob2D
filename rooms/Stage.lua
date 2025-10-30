Stage = Object:extend()

local function bindInputPlayer()

	GInput:bind("a", "left")
	GInput:bind("d", "right")
	GInput:bind("w", "up")
	GInput:bind("s", "down")

	GInput:bind("p", "pause")

	GInput:bind("down", "shootdown")
	GInput:bind("up", "shootup")
	GInput:bind("left", "shootleft")
	GInput:bind("right", "shootright")
	GInput:bind("space", "boosting")

	GInput:bind("wheelup", "zoomIn")
	GInput:bind("wheeldown", "zoomOut")
end

function Stage:new()
	bindInputPlayer()
	
	-- area menu
	self.areaMenu = Area(self)
	self.menu  = self.areaMenu:addGameObject("Menu", 0,0)


	-- player area
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
	self.pauseGame = false
	GCamera.smoother = Camera.smooth.damped(100)

	self.time = 0
	self.isPlayerDead = false
	self.timer = Timer() -- Initialize the timer

	self.hTransition = 0
end

-- check if it correct
function Stage:update(dt)
	--GCamera:lockPosition(dt, GW / 2, GH / 2)
	if GInput:pressed("pause") then
		self:startTransition()
		self.areaMenu:update(dt)
		self.pauseGame = not self.pauseGame
	else
		GCamera:update(dt)
		self.time = self.time + dt
		self.timer:update(dt)
		if self.player then
			self.director:update(dt)
			self.area:update(dt)
		end

		if (not self.player) then
			self:destroy()
		end
	end
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

function Stage:startTransition(var)
	for index, _ in pairs(self) do
		if index == var then
			self[index] = not self[index]
			print("Starting transition for:", var)
			break
		end
	end

	self.timer:tween(0.5, self, { hTransition = GW * SX, }, 'in-out-cubic',
		function()
			self.timer:tween(0.5, self, { hTransition = 0 }, 'in-out-cubic',
				function()
					print("Finished transition", self.hTransition)
					self.isPlayerDead = false
					self.director = Director(self, self.player)
				end)
		end)
end

function Stage:finishTransition()
	self.isPlayerDead = true

	self.timer:tween(0.5, self, { hTransition = GW * SX, }, 'in-out-cubic',
		function()
			self.timer:tween(0.5, self, { hTransition = 0 }, 'in-out-cubic',
				function()
					print("Finished transition", self.hTransition)
					self.isPlayerDead = false
					self.director = Director(self, self.player)
				end)
		end)
end

function Stage:drawRGBShift()
	love.graphics.setCanvas(self.rgbShiftCanvas)
	love.graphics.clear()
	GCamera:attach(0, 0, GW, GH)
	self.area:drawOnly({ 'rgb_shift' })
	GCamera:detach()
	love.graphics.setCanvas()
end

function Stage:drawMain()
	love.graphics.setCanvas(self.main_canvas)
	love.graphics.clear()
	GCamera:attach(0, 0, GW, GH)
	self.area:drawExcept({ 'rgb_shift' })
	GCamera:detach()
end

function Stage:draw()
	if not self.player then
		return
	end
	if self.pauseGame then
		self.areaMenu:draw()
	else
		self:drawRGBShift()
		self:drawMain()

		if self.isPlayerDead then
			love.graphics.setColor(0.87, 1, 0.81, 1.0)
			-- Note: You may need to adjust this rectangle's position and size
			-- depending on your scaling, but at least it will be visible now.
			love.graphics.rectangle('fill', 0, 0, GW * SX, self.hTransition)
			love.graphics.setColor(1, 1, 1, 1)
		end


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
		self.crtShader:send('iTime', self.time * 10)

		love.graphics.draw(self.final_canvas, x, y, 0, SX, SY)
		love.graphics.setShader()
		love.graphics.setBlendMode('alpha')
	end
end

function Stage:finish()
	GTimer:after(0.5, function()
		self:reset()
		if not Achievements['10K Fighter'] then
			Achievements['10k Fighter'] = true
		end
	end)
end

function Stage:reset()
	print("Reset Stage")
	GCamera:lookAt(GW / 2, GH / 2)

	self.director:destroy()
	self.area:reset()
	--self.area = nil
	self.player = nil
	self.player = self.area:addGameObject("Player", GW / 2, GH / 2)
	self.score = 0
	self.goalScore = 30
	self.font = GFont
	self.counterAttack = 0
	self.starGameInfo = self.area:addGameObject("StartGameInfo", 0, 0)

	GCamera.smoother = Camera.smooth.damped(100)
	self.time = 0
end
