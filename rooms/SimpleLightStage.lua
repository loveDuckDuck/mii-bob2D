SimpleLightStage = Object:extend()

function SimpleLightStage:new() -- Create new stage object 📝
	print("stage created") -- Log stage creation ✅
	self.lightWorld = Lib.World.new()
	self.ligth = self.lightWorld:add(200, 200, 200, 1, 0, 0)
		self.main_canvas = love.graphics.newCanvas(gw, gh) -- Create main canvas object 🖼️

    GlobalCamera.smoother = Camera.smooth.damped(100)
end

function SimpleLightStage:update(dt) -- Update stage logic here 🕹️
	GlobalCamera:lockPosition(dt, gw / 2, gh / 2)
	GlobalCamera:update(dt)
	self.ligth.x, self.ligth.y = love.mouse.getPosition()
end

function SimpleLightStage:draw() -- Drawing stage visuals here 🎨
	-- reset light world
	self.lightWorld:begin()
	love.graphics.setCanvas(self.main_canvas) -- Set main canvas target 🎯
	love.graphics.clear() -- Clear the current frame 🧹
	--GlobalCamera:attach()
	GlobalCamera:attach(0, 0, gw, gh)

	for i = 1, 10 do
		DraftDrawer:rhombus(100 + i * 70, 300, 10,10, "fill")
	end

	-- track shadow objects
	self.lightWorld:track_obj()
	for i = 1, 10 do
		DraftDrawer:rhombus(100 + i * 70, 300, 10,10, "fill")
	end
	-- draw background
	self.lightWorld:track_bg()

	for i = 1, 10 do
		DraftDrawer:rhombus(100 + i * 70, 300, 10, 10,"fill")
	end
	-- draw scene, light and shadow
	self.lightWorld:finish()
	GlobalCamera:detach()
	love.graphics.setCanvas() -- Reset the canvas 🔄

	love.graphics.setColor(1, 1, 1, 1) -- New 0-1 range for LÖVE 11.5
	love.graphics.setBlendMode("alpha", "premultiplied") -- Set blend mode here ⚙️

	local x = (love.graphics.getWidth() - gw * sx) / 2
	local y = (love.graphics.getHeight() - gh * sy) / 2
	love.graphics.draw(self.main_canvas, x, y, 0, sx, sy)

	love.graphics.setBlendMode("alpha") -- Reset the blend mode 🔄
end

function SimpleLightStage:destroy()
	self.area:destroy()
	self.area = nil
end
