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
	self.font = Font
	self.counterAttack = 0

	GInput:bind("p", function()
			Slow(0.15, 1)

		self:destroy()
	end)

	GCamera.smoother = Camera.smooth.damped(100)
	triangle = love.graphics.newShader("resource/shaders/rgbShift.frag")
end

function Stage:update(dt)
	self.director:update(dt)
	GCamera:lockPosition(dt, GW / 2, GH / 2)
	GCamera:update(dt)
	self.area:update(dt)
	if (self.player.dead) then
		self:destroy()
	end
end

function Stage:draw()
	if self.area == nil then
		print("Area is nil, cannot draw Stage") --- IGNORE ---
		return
	end
	love.graphics.setCanvas(self.main_canvas)
	love.graphics.clear()
	GCamera:attach(0, 0, GW, GH)
	self.area:draw()
	GCamera:detach()

	-- Score
	love.graphics.setColor(G_default_color)
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
	local r, g, b = unpack(G_hp_color)
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
	self:finish()
end

function Stage:finish()
	GTimer:after(1, function()
		self.area:destroy()
		self.director = nil
		self.area = nil
		GRoom:removeRoom("Stage")

		GRoom:gotoRoom('Stage', UUID())

		if not Achievements['10K Fighter'] and self.score >= 10000 then
			Achievements['10K Fighter'] = true
			-- Do whatever else that should be done when an achievement is unlocked
		end
	end)
end
