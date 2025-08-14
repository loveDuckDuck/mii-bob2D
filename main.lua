-- in main.lua
Object = require 'libraries/classic/classic'
Input = require 'libraries/input/Input'
Timer = require 'libraries/hump/timer'
EnhancedTimer = require 'libraries/enhanced_timer/EnhancedTimer'


-- define hear all the local main variables

local dt
local current_room
local circle_room
local rectangle_room
local input_handler



function recursiveEnumerate(folder, file_list)
	local items = love.filesystem.getDirectoryItems(folder)
	for _, item in ipairs(items) do
		local file = folder .. '/' .. item
		if love.filesystem.getInfo(file) then
			table.insert(file_list, file)
		elseif love.filesystem.isDirectory(file) then
			recursiveEnumerate(file, file_list)
		end
	end
end

function requireFiles(files)
	for _, file in ipairs(files) do
		local file = file:sub(1, -5)
		require(file)
	end
end

function love.draw()
	if current_room then current_room:draw() end
	circle_room:draw()
	rectangle_room:draw()
end

function love.update(dt)
	if current_room then current_room:update(dt) end
	if input_handler:pressed('add_circle') then
		print("add circle to the room")
		circle_room:addCircle(love.math.random(0, love.graphics.getWidth()),
			love.math.random(0, love.graphics.getHeight()),
			love.math.random(1, 100))
	end
	if input_handler:pressed('add_rectangle') then
		print("add rectangle to the room")
		rectangle_room:addRectangle(
			love.math.random(1, 100),
			love.math.random(1, 100),
			love.math.random(0, love.graphics.getWidth()),
			love.math.random(0, love.graphics.getHeight()),
			{ love.math.random(), love.math.random(), love.math.random() })
	end

	circle_room:update(dt)
	rectangle_room:update(dt)
end

function gotoRoom(room_type, ...)
	current_room = _G[room_type](...)
end

function love.load()
	local object_files = {}
	recursiveEnumerate('objects', object_files)
	requireFiles(object_files)

	local room_files = {}

	recursiveEnumerate('rooms', room_files)
	requireFiles(room_files)

	current_room = nil
	circle_room = CircleRoom()
	rectangle_room = RectangleRoom()

	input_handler = Input()
	input_handler:bind('1', 'add_circle')
	input_handler:bind('2', 'add_rectangle')
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
