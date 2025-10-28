RoomTransiction = Object:extend()

function RoomTransiction:new()
	self.y_offset = 0

	self.w, self.h = GW, 0
	self.isInLife = true
	self.timer = Timer() -- Initialize the timer
	self.crtShader = love.graphics.newShader('resource/shaders/crtShader.frag')
	self.time = 0
end

function RoomTransiction:update(dt)
	self.timer:update(dt)
end

function RoomTransiction:startCoroutineTransition()
	local co = coroutine.create(function()
		print("Starting room transition...")
		GRoomTransition:startTransiction()
	end)
	coroutine.resume(co)
end

function RoomTransiction:draw()
	if self.isInLife then
		return
	end
	
	love.graphics.setShader(self.crtShader)
	self.crtShader:send('iResolution', { love.graphics.getWidth(), love.graphics.getHeight() })
	self.crtShader:send('iTime', self.time * 10)
	love.graphics.rectangle('fill', 0, 0, GW * SX, self.h)
	love.graphics.setColor(0.87, 1, 0.81, 1.0)
	love.graphics.rectangle('fill', GW/2, GH/2, 100, self.h)

	love.graphics.setShader()
end

function RoomTransiction:startTransiction()
	self.isInLife = false
	self.timer:tween(0.7, self, { h = GW * SX, }, 'in-out-cubic',
		function()
			self.timer:tween(0.7, self, { h = 0 }, 'in-out-cubic',
				function()
					self.isInLife = true
				end)
		end)
end

function RoomTransiction:destroy()
	self.timer:destroy()
end

return RoomTransiction
