Stage = Object:extend()

function Stage:new() -- Create new stage object 📝
	print("stage created") -- Log stage creation ✅
	self.area = Area(self) -- Create an area instance 🗺️

	self.area:addPhysicsWorld()
	self.area.world:addCollisionClass("Player")
	self.area.world:addCollisionClass("Projectile", { ignores = { "Player" } }) -- the world need to check
	self.area.world:addCollisionClass("Collectable", { ignores = { "Player", "Projectile" } })
	self.area.world:addCollisionClass("Enemy")
	self.area.world:addCollisionClass("EnemyProjectile", { ignores = { "EnemyProjectile", "Projectile", "Enemy" } })

	self.main_canvas = love.graphics.newCanvas(gw, gh) -- Create main canvas object 🖼️
	-- when instante this stage
	self.player = self.area:addGameObject("Player", GlobalWordlSizeX / 2, GlobalWordlSizeY / 2)

	self.director = Director(self, self.player) -- Create a director instance 🎬
	self.score = 0
	self.font = Font
	--[[
	XXX : remaind to fix
	]]
	InputHandler:bind("p", function()
		self.area:addGameObject("Ammo", GlobalRandom(0, GlobalWordlSizeX), GlobalRandom(0, GlobalWordlSizeY))
		self.area:addGameObject(
			"BoostCoin",
			GlobalRandom(self.player.x - gw / 2, self.player.x + gw / 2),
			GlobalRandom(self.player.y - gh / 2, self.player.y + gh / 2)
		)
		self.area:addGameObject(
			"ResourceCoin",
			GlobalRandom(self.player.x - gw / 2, self.player.x + gw / 2),
			GlobalRandom(self.player.y - gh / 2, self.player.y + gh / 2)
		)

		self.area:addGameObject(
			"Rock",
			GlobalRandom(self.player.x - gw / 2, self.player.x + gw / 2),
			GlobalRandom(self.player.y - gh / 2, self.player.y + gh / 2)
		)
		self.area:addGameObject(
			"Shooter",
			GlobalRandom(self.player.x - gw / 2, self.player.x + gw / 2),
			GlobalRandom(self.player.y - gh / 2, self.player.y + gh / 2)
		)
	end)
	GlobalCamera.smoother = Camera.smooth.damped(100)
end

function Stage:update(dt) -- Update stage logic here 🕹️
	self.director:update(dt)
	--GlobalCamera:lockPosition(dt, gw / 2, gh / 2)
	GlobalCamera:lookAt(self.player.x, self.player.y)
	GlobalCamera:update(dt)
	--	print(self.player.x .. " " .. self.player.y)
	self.area:update(dt) -- Update the area too 👍
end

function Stage:draw() -- Drawing stage visuals here 🎨
	love.graphics.setCanvas(self.main_canvas) -- Set main canvas target 🎯
	love.graphics.clear() -- Clear the current frame 🧹

	--GlobalCamera:attach()
	GlobalCamera:attach(0, 0, gw, gh)
	self.area:draw() -- Draw the area now 👀

	GlobalCamera:detach()
	-- Score
	love.graphics.setColor(G_default_color)
	love.graphics.print(
		self.score,
		gw - 20,
		10,
		0,
		1,
		1,
		math.floor(self.font:getWidth(self.score) / 2),
		self.font:getHeight() / 2
	)
	love.graphics.setColor(255, 255, 255)
	-- HP
	local r, g, b = unpack(G_hp_color)
	local hp, max_hp = self.player.hp, self.player.max_hp
	love.graphics.setColor(r, g, b)
	love.graphics.rectangle("fill", gw / 2 - 52, gh - 16, 48 * (hp / max_hp), 4)
	love.graphics.setColor(r - 32 / 255, g - 32 / 255, b - 32 / 255)
	love.graphics.rectangle("line", gw / 2 - 52, gh - 16, 48, 4)

	love.graphics.setCanvas() -- Reset the canvas 🔄

	love.graphics.setColor(1, 1, 1, 1) -- New 0-1 range for LÖVE 11.5
	love.graphics.setBlendMode("alpha", "premultiplied") -- Set blend mode here ⚙️
	--[[
        XXX: PROBLEM WITH RESOLUZIO AND SCALE NEED TO UNDERSTAND
    ]]
	local x = (love.graphics.getWidth() - gw * sx) / 2
	local y = (love.graphics.getHeight() - gh * sy) / 2
	love.graphics.draw(self.main_canvas, x, y, 0, sx, sy)

	love.graphics.setBlendMode("alpha") -- Reset the blend mode 🔄
	-- score
end

function Stage:destroy()
	self.area:destroy()
	self.area = nil
end
