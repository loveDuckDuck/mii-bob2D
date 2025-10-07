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
	--[[
	XXX : remaind to fix
	]]
	GInput:bind("p", function()
		self.area:addGameObject(
			"Ammo",
			math.customRandom(self.player.x - GW / 2, self.player.x + GW / 2),
			math.customRandom(self.player.y - GH / 2, self.player.y + GH / 2)
		)

		self.area:addGameObject(
			"BoostCoin",
			math.customRandom(self.player.x - GW / 2, self.player.x + GW / 2),
			math.customRandom(self.player.y - GH / 2, self.player.y + GH / 2)
		)

		self.area:addGameObject(
			"HpCoin",
			math.customRandom(self.player.x - GW / 2, self.player.x + GW / 2),
			math.customRandom(self.player.y - GH / 2, self.player.y + GH / 2)
		)
	end)
	GInput:bind("z", function()
		self.counterAttack = self.counterAttack + 1
		if self.counterAttack > Lenght(Attacks) then
			self.counterAttack = 1
		end
		self.player:setAttack(table.keys(Attacks)[self.counterAttack])
	end)

	GCamera.smoother = Camera.smooth.damped(100)
end

function Stage:update(dt)
	self.director:update(dt)
	GCamera:lockPosition(dt, GW / 2, GH / 2)
	GCamera:update(dt)
	self.area:update(dt)
end

function Stage:draw()
	love.graphics.setCanvas(self.main_canvas)
	love.graphics.clear()
	GCamera:attach(0, 0, GW, GH)
	self.area:draw()
	GCamera:detach()
	love.graphics.setCanvas()

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

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setBlendMode('alpha', 'premultiplied')
	local x = (love.graphics.getWidth() - GW * sx) / 2
	local y = (love.graphics.getHeight() - GH * sy) / 2
	love.graphics.draw(self.main_canvas, x, y, 0, sx, sy)
	love.graphics.setBlendMode('alpha')
end

function Stage:destroy()
	self.area:destroy()
	self.area = nil
end
