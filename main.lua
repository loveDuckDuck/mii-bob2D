-- in main.lua

Object = require("libraries/classic/classic")

Loader = require("Loader")

Input = require("libraries/input/Input")
Timer = require("libraries/enhanced_timer/EnhancedTimer")
Camera = require("libraries/hump/camera")
Push = require("libraries/push/push")
--EnhancedTimer = require 'libraries/enhanced_timer/EnhancedTimer'
Physics = require("libraries/windfield")
--utilities
Util = require("utils/Utils")
RoomController = require("utils/RoomController")
--Area = require 'gameObject/Area'

function flash(frames)
	FlashFrames = frames
end

function resize(s)
	love.window.setMode(s * gw, s * gh)
	sx, sy = s, s
end

function love.resize(widht, height)
	Push:resize(widht, height)
end

function love.draw()
	GlobalRoomController:draw()
	DrawGarbageCollector()
end

function love.update(dt)
	if InputHandler:pressed("DeleteEveryThing") then
		DeleteEveryThing()
	end

	GlobalRoomController:update(dt * GlobalSlowAmount)
	--Timer:update(dt * GlobalSlowAmount)
	GlobalCamera:update(dt * GlobalSlowAmount)
end

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.graphics.setLineStyle("rough")

	loader = Loader()
	loader:getRequireFiles("gameObject")
	loader:getRequireFiles("objects")
	loader:getRequireFiles("gameFolder/Stage")

	InputHandler = Input()
	InputHandler:bind("a", "a")
	InputHandler:bind("d", "d")
	InputHandler:bind("w", "w")
	InputHandler:bind("s", "s")
	InputHandler:bind("b", "b")
	InputHandler:bind("space", "boosting")

	InputHandler:bind("down", "down")
	InputHandler:bind("up", "up")
	InputHandler:bind("left", "left")
	InputHandler:bind("right", "right")

	InputHandler:bind("escape", "DeleteEveryThing")

	GlobalTimer = Timer()
	GlobalCamera = Camera()
	GlobalRoomController = RoomController()

	GlobalRoomController:gotoRoom("Stage", UUID())
	resize(2)
	GlobalSlowAmount = 1
	FlashFrames = 0
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
