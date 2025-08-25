-- in main.lua

Loader = require 'Loader'

Object = require 'libraries/classic/classic'
Input = require 'libraries/input/Input'
Timer = require 'libraries/enhanced_timer/EnhancedTimer'
Camera = require 'libraries/hump/camera'
--EnhancedTimer = require 'libraries/enhanced_timer/EnhancedTimer'
Physics = require 'libraries/windfield'
--utilities
Util = require 'utils/Utils'
RoomController = require 'utils/RoomController'
--Area = require 'gameObject/Area'


-- define hear all the local main variables
-- loader of all the require in a specific folder
local loader
-- room_controller controller
local room_controller

function love.resize(s)
	UpdateScale() -- Recalculate scale when window is resized
	--love.window.setMode(s * gw, s * gh)
end

function resize(s)
	love.window.setMode(s * gw, s * gh)
	sx, sy = s, s
end

function love.draw()
	room_controller:draw()
	DrawGarbageCollector()
end

function love.update(dt)
	room_controller:update(dt)
	--Timer:update(dt * GlobalSlowAmount)
	GlobalCamera:update(dt * 	GlobalSlowAmount)
end

function love.load()
	love.graphics.setDefaultFilter('nearest')
	love.graphics.setLineStyle('rough')
	loader = Loader()
	loader:getRequireFiles('gameObject')
	loader:getRequireFiles('objects')
	loader:getRequireFiles('rooms')
	loader:getRequireFiles('gameFolder/Stage')

	InputHandler = Input()
	InputHandler:bind('a', 'a')
	InputHandler:bind('d', 'd')
	InputHandler:bind('w', 'w')
	InputHandler:bind('s', 's')
	InputHandler:bind('down', 'down')
	InputHandler:bind('up', 'up')
	InputHandler:bind('left', 'left')
	InputHandler:bind('right', 'right')


	GlobalCamera = Camera()
	room_controller = RoomController()

	room_controller:gotoRoom('Stage', 1)
	InputHandler:bind('f1', function()
		print("Before collection: " .. collectgarbage("count") / 1024)
		collectgarbage()
		print("After collection: " .. collectgarbage("count") / 1024)
		print("Object count: ")
		local counts = type_count()
		for k, v in pairs(counts) do print(k, v) end
		print("-------------------------------------")
	end)
	love.resize()
	GlobalSlowAmount = 1
	--resize(3)
end

function love.run()
	local dt

	if love.math then -- check if love.math is nil, because we need it
		love.math.setRandomSeed(os.time())
	end

	if love.load then
		love.load()
	end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then
		love.timer.step()
		dt = love.timer.getDelta() -- with this im gone insert define the fixed delta time
	end


	-- Main loop time.
	while true do
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a, b, c, d, e, f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a
					end
				end
				love.handlers[name](a, b, c, d, e, f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then
			love.timer.step()
			dt = love.timer.getDelta()
		end

		-- Call update and draw
		if love.update then
			love.update(dt)
		end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.clear(love.graphics.getBackgroundColor())
			love.graphics.origin()
			if love.draw then
				love.draw()
			end
			love.graphics.present()
		end

		if love.timer and (love.window.getVSync() == 0) then
			-- print("nos sleep")
			love.timer.sleep(0.001)
		else
			--print("vSync enabled")
		end
	end
end
