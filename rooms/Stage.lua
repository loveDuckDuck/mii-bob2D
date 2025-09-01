Stage = Object:extend()

function Stage:new() -- Create new stage object 📝
	print("stage created") -- Log stage creation ✅
	self.area = Area(self) -- Create an area instance 🗺️

	self.area:addPhysicsWorld()
	self.area.world:addCollisionClass("Player")
	self.area.world:addCollisionClass("Projectile", { ignores = { "Projectile" } }) -- the world need to check
	self.area.world:addCollisionClass("Collectable", { ignores = { "Player", "Projectile" } })

	self.main_canvas = love.graphics.newCanvas(gw, gh) -- Create main canvas object 🖼️
	-- when instante this stage
	self.player = self.area:addGameObject("Player", GlobalWordlSizeX / 2, GlobalWordlSizeY / 2)

	InputHandler:bind("p", function()
		self.area:addGameObject("Ammo", GlobalRandom(0, GlobalWordlSizeX), GlobalRandom(0, GlobalWordlSizeY))
		self.area:addGameObject("BoostCoin", GlobalRandom(self.player.x - gw/2, self.player.x + gw/2), GlobalRandom(self.player.y - gh/2, self.player.y + gh/2))
	
	end)
		GlobalCamera.smoother = Camera.smooth.damped(100)

end

function Stage:update(dt) -- Update stage logic here 🕹️
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
end

function Stage:destroy()
	self.area:destroy()
	self.area = nil
end
