
--[[
-- in main.lua
Object = require 'libraries/classic/classic'
Input = require 'libraries/input/Input'
Timer = require 'libraries/hump/timer'
EnhancedTimer = require 'libraries/enhanced_timer/EnhancedTimer'


-- define hear all the local main variables
local test_circle
local test_hypercircle
local test_rectangle
local dt
local input
local sum_table
local rect_1
local rect_2
local timer = Timer()
local hp = 100


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
	test_circle:draw()
	test_hypercircle:draw()
	test_rectangle:draw()
	rect_1:draw()
	rect_2:draw()
end

-- TODO TRY TO UNDERSTAND WHY IT DOESNT WORK
function love.keypressed(key)
	if key == 'r' then
		--print("R")
		--timer:after('r_key_press', 2, function() print(love.math.random()) end)
	end
end

function love.update(dt)
	test_circle:update(dt)
	test_hypercircle:update(dt)
	test_rectangle:update(dt)
	rect_1:update(dt)
	rect_2:update(dt)

	if input:down('left_click', 0.5) then print("zio pera ") end
	if input:pressed('left_click') then print('pressed') end
	if input:released('left_click') then print('released') end

	-- use the system of the coordinate in the 0,0 in top left
	-- so when you move remember going y is negative to go up
	-- also y is positivo if you wont to go down
	if input:down('up') then
		print('up')
		test_hypercircle:move(0, -1)
	end
	if input:down('left') then
		print('left')
		test_hypercircle:move(-1, 0)
	end
	if input:down('right') then
		print('right')
		test_hypercircle:move(1, 0)
	end
	if input:down('down') then
		print('down')
		test_hypercircle:move(0, 1)
	end
	if input:down('add') then
		print('add')
		sum_table:add()
		print(sum_table.value)
	end
	-- try to conmect all of this input to the joupad



	-- now update the timer a run time
	timer:update(dt)
end

function love.load()
	local object_files = {}
	recursiveEnumerate('objects', object_files)
	requireFiles(object_files)
	-- add all my forms
	test_circle = Circle(400, 400, 100)
	test_hypercircle = HyperCircle(200, 200, 50, 3, 100)
	test_rectangle = Rectangle(50, 50, 500, 500, { 1, 0, 0 })
	sum_table = createSumTable(1, 2, 3)
	print(sum_table.value)
	sum_table:sum()
	print(sum_table.value)

	-- here im gone insert all my binding for the keyboaard
	input = Input()
	input:bind('mouse1', 'left_click')
	input:bind('w', 'up')
	input:bind('a', 'left')
	input:bind('d', 'right')
	input:bind('s', 'down')
	input:bind('1', 'add')

	-- define the timer insider the load functions

	timer:every(5, function()
		timer:tween(2, test_circle, { radius = 50 }, 'in-out-cubic', function()
			timer:tween(2, test_circle, { radius = 100 }, 'in-out-cubic')
		end)
	end)

	timer:every(3, function()
		timer:tween(1, test_hypercircle, { outer_radius = 100 }, 'in-sine', function()
			timer:tween(1, test_hypercircle, { outer_radius = 10 }, 'in-sine')
		end)
	end)


	rect_1 = Rectangle(100, 400, 10, 10, { 222 / 255, 64 / 255, 64 / 255 })
	rect_2 = Rectangle(100, 400, 10, 10, { 255 / 255, 0 / 255, 0 / 255 })
end

function love.run()
	-- Make the window resizable with vsync disabled and a minimum size
	if love.window then
		-- love.window.setMode(800, 600, { resizable = true, vsync = 1, minwidth = 400, minheight = 300 })
		love.window.setVSync(1)
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
]]