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

	self.main_canvas = love.graphics.newCanvas(GW, GH)                                                 -- Create main canvas object 🖼️
	-- when instante this stage
	self.player = self.area:addGameObject("Player", GW / 2, GH / 2)

	self.director = Director(self, self.player)

	self.score = 0
	self.font = GFont
	self.counterAttack = 0
	self.starGameInfo = self.area:addGameObject("StartGameInfo", 0, 0)

	GCamera.smoother = Camera.smooth.damped(100)
	--triangle = love.graphics.newShader("resource/shaders/rgbShift.frag")
	GInput:bind("p", function()
		self:destroy()
	end)


	
end

function Stage:update(dt)
	GCamera:lockPosition(dt, GW / 2, GH / 2)
	GCamera:update(dt)

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

function Stage:draw()
	if not self.player then
		return
	end
	love.graphics.setCanvas(self.main_canvas)
	love.graphics.clear()
	GCamera:attach(0, 0, GW, GH)
	self.area:draw()
	GCamera:detach()

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
	love.graphics.setColor(1, 1, 1)

	-- HP
	local r, g, b = unpack(GHPColor)
	local hp, max_hp = self.player.hp, self.player.max_hp
	love.graphics.setColor(r, g, b)
	love.graphics.rectangle("fill", GW / 2 - 52, GH - 16, 156 * (hp / max_hp), 7)
	love.graphics.setColor(r - 32 / 255, g - 32 / 255, b - 32 / 255)
	love.graphics.rectangle("line", GW / 2 - 52, GH - 16, 156, 7)

	love.graphics.setCanvas()


	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setBlendMode('alpha', 'premultiplied')
	local x = (love.graphics.getWidth() - GW * SX) / 2
	local y = (love.graphics.getHeight() - GH * SY) / 2
	love.graphics.draw(self.main_canvas, x, y, 0, SX, SY)
	love.graphics.setBlendMode('alpha')
end

function Stage:destroy()
	self.director:destroy()
	self.area:destroy()
	self.area = nil
	self.player = nil

	--table.clear(self)
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
