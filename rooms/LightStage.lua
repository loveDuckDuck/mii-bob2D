LightStage = Object:extend()

function LightStage:new() -- Create new stage object 📝
	print("stage created") -- Log stage creation ✅
	self.area = Area(self) -- Create an area instance 🗺️

	self.area:addPhysicsWorld()
	self.main_canvas = love.graphics.newCanvas(gw, gh) -- Create main canvas object 🖼️

	self.shadowMap = Bitumbra.newShadowMap(gw, gh)  -- Create shadow map for lighting effects 💡
	self.occulusionMap = Bitumbra.newOcclusionMesh()

	--add a bunch of edges
	self.occulusionMap:addEdge(gw / 2 - 50, gh / 2 - 50, gw / 2 + 50, gh / 2 - 50) -- ax,ay, bx,by
	self.occulusionMap:addEdge(gw / 2 + 50, gh / 2 - 50, gw / 2 + 50, gh / 2 + 50)
	self.occulusionMap:addEdge(gw / 2 + 50, gh / 2 + 50, gw / 2 - 50, gh / 2 + 50)
	self.occulusionMap:addEdge(gw / 2 - 50, gh / 2 + 50, gw / 2 - 50, gh / 2 - 50)


	self.circles = Bitumbra.newOcclusionMesh()
	local a = 0
	for i = 1, 16 do
		local x, y = math.cos(a), math.sin(a)
		self.circles:addCircle(gw / 2 + x * 180, gh / 2 + y * 180, 20, 24)
		a = a + math.pi / 8
	end
	self.lights = Bitumbra.newLightsArray()
	--add a bunch of lights, all 128 to be precise
	for y = 1, 8 do
		for x = 1, 16 do
			self.lights:push(gw / 16 * x - gw / 32, gh * y / 8 - gh / 16, 400, .02, .02, .02)
		end
	end
	self.count = self.occulusionMap.edge_count
	GlobalCamera.smoother = Camera.smooth.damped(100)
end

function LightStage:update(dt) -- Update stage logic here 🕹️
	GlobalCamera:lockPosition(dt, gw / 2, gh / 2)
	GlobalCamera:update(dt)
	--reset edge count to static
	self.occulusionMap.edge_count = self.count
	--move dynamic meshes
	self.circles:applyTransform(gw / 2, gh / 2, dt / 10, 1, 1, gw / 2, gh / 2)
	--and add them to the geometry mesh
	self.occulusionMap:addOcclusionMesh(self.circles)
	--move one light to the mouse position(also make it brighter)
	local mx, my = love.mouse.getPosition()
	self.lights:set(1, mx, my, 500, .3, .3, .3)
	--	print(self.player.x .. " " .. self.player.y)
	self.area:update(dt) -- Update the area too 👍
end

function LightStage:draw()                 -- Drawing stage visuals here 🎨
	love.graphics.setCanvas(self.main_canvas) -- Set main canvas target 🎯
	love.graphics.clear()                  -- Clear the current frame 🧹

	--GlobalCamera:attach()
	GlobalCamera:attach(0, 0, gw, gh)

	self.shadowMap:render(self.occulusionMap, self.lights)
	self.lights:draw(self.shadowMap)

	--	self.area:draw() -- Draw the area now 

	GlobalCamera:detach()
	love.graphics.setCanvas()                         -- Reset the canvas 🔄

--	love.graphics.setColor(1, 1, 1, 1)                -- New 0-1 range for LÖVE 11.5
	love.graphics.setBlendMode("alpha", "premultiplied") -- Set blend mode here ⚙️

	local x = (love.graphics.getWidth() - gw * sx) / 2
	local y = (love.graphics.getHeight() - gh * sy) / 2
	love.graphics.draw(self.main_canvas, x, y, 0, sx, sy)

	love.graphics.setBlendMode("alpha") -- Reset the blend mode 🔄
end

function LightStage:destroy()
	self.area:destroy()
	self.area = nil
end
