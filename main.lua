-- in main.lua
require 'objects/Test'
Object = require 'libraries/classic/classic'
Input = require 'libraries/input/Input'

-- define hear all the local main variables
local test_circle
local test_hypercircle
local test_rectangle
local dt
local input
local sum_table



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
end

function love.update(args)
	test_circle:update(dt)
	test_hypercircle:update(dt)
	test_rectangle:update(dt)
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

end

function love.load()
	local object_files = {}
	recursiveEnumerate('objects', object_files)
	requireFiles(object_files)
	-- add all my forms
	test_circle = Circle(100, 100, 100)
	test_hypercircle = HyperCircle(200, 200, 50, 3, 100)
	test_rectangle = Rectangle(50, 50, 500, 500)
	sum_table = createSumTable(1, 2, 3)
	print(sum_table.value)
	sum_table:sum()
	print(sum_table.value)


	input = Input()
	input:bind('mouse1', 'left_click')
	input:bind('w', 'up')
	input:bind('a', 'left')
	input:bind('d', 'right')
	input:bind('s', 'down')
	input:bind('1', 'add')


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
		love.load(arg)
	end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then
		love.timer.step()
		dt = love.timer.getDelta() -- with this im gone insert define the fixed delta time
	end

	local dt = 0

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
			-- print("vSync enabled")
		end
	end
end
