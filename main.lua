-- in main.lua
Object = require 'libraries/classic/classic'
Input = require 'libraries/input/Input'
Timer = require 'libraries/hump/timer'
EnhancedTimer = require 'libraries/enhanced_timer/EnhancedTimer'
--utilities
Loader = require 'utils/Loader'
Util = require 'utils/Utils'
RoomController = require 'utils/RoomController'


-- define hear all the local main variables

local dt
local input_handler
-- loader of all the require in a specific folder
local loader
-- room_controller controller
local room_controller

local circle_room
local rectangle_room


function love.draw()
	room_controller:draw()
end

function love.update(dt)

	if input_handler:pressed('CircleRoom') then
		print("to circle_room")
		room_controller:gotoRoom('CircleRoom', 1)
	end
	if input_handler:pressed('RectangleRoom') then
		print("to rectangle_room")
		room_controller:gotoRoom('RectangleRoom', 2)
	end

	if room_controller.current_room then room_controller.current_room:update(dt) end
	if room_controller.current_room then
		if input_handler:pressed('add_circle') and room_controller.current_room.type == "CircleRoom" then
			print("add circle to the room_controller")
			room_controller.current_room:addCircle(
				love.math.random(0, love.graphics.getWidth()),
				love.math.random(0, love.graphics.getHeight()),
				love.math.random(1, 100))
		end
		if input_handler:pressed('add_rectangle') and room_controller.current_room.type == "RectangleRoom" then
			print("add rectangle to the room_controller")
			room_controller.current_room:addRectangle(
				love.math.random(1, 100),
				love.math.random(1, 100),
				love.math.random(0, love.graphics.getWidth()),
				love.math.random(0, love.graphics.getHeight()),
				{ love.math.random(), love.math.random(), love.math.random() })
		end
	end
	room_controller:update(dt)
end



function love.load()
	loader = Loader()
	loader:getRequireFiles('objects')
	loader:getRequireFiles('rooms')

	room_controller = RoomController()


	input_handler = Input()
	input_handler:bind('a', 'add_circle')
	input_handler:bind('a', 'add_rectangle')

	input_handler:bind('f1', 'CircleRoom')
	input_handler:bind('f2', 'RectangleRoom')
end

function love.run()
	-- Make the window resizable with vsync disabled and a minimum size
	if love.window then
		love.window.setMode(800, 600, { resizable = true, vsync = 1, minwidth = 400, minheight = 300 })


		--love.window.setVSync(1)
	end
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
