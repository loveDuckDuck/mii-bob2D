-- main.lua
local ciao <const> = "zzz"

function love.load()
	-- Load the shader (save the shader code as "blackhole.glsl")
	

	blackhole_shader = love.graphics.newShader("blackhole.glsl")
	triangle = love.graphics.newShader("triangle.glsl")
	noise = love.graphics.newImage("noise.png")
	mask = love.graphics.newImage("mask.png") -- Replace with your image

	-- Create a test image to distort (you can use any image)
	love.graphics.setDefaultFilter("linear", "linear")
	test_image = love.graphics.newImage("water.png") -- Replace with your image


	triangle:send("simplex", noise)
	triangle:send("mask", mask)

	-- Shader parameters
	center_x = love.graphics.getWidth() / 2
	center_y = love.graphics.getHeight() / 2
	black_hole_radius = 150
	distortion_strength = 0.5

	-- Set initial shader values
	blackhole_shader:send("center_pos", { center_x, center_y })
	blackhole_shader:send("radius", black_hole_radius)
	blackhole_shader:send("strength", distortion_strength)
end

function love.update(dt)
	-- Optional: Make the black hole follow the mouse
	center_x = love.mouse.getX()
	center_y = love.mouse.getY()

	-- Update shader with new center position
	blackhole_shader:send("center_pos", { center_x, center_y })

	-- Optional: Animate the strength
	distortion_strength = 0.5 + 0.3 * math.sin(love.timer.getTime() * 2)
	blackhole_shader:send("strength", distortion_strength)
	triangle:send("time", love.timer.getTime())

end

function love.draw()
	-- Use the shader
	love.graphics.setShader(triangle)
	love.graphics.push()
	love.graphics.scale(4, 4)
	love.graphics.draw(test_image, love.graphics.getWidth() / 8, love.graphics.getHeight() / 8) -- '/ 0.5' because scale affects everything, including position obviously
	love.graphics.pop()                                                                      -- so the scale doesn't affect anything else
	-- Draw your content that will be distorted

	-- You can also draw shapes, text, or other images here
	-- They will all be affected by the black hole distortion

	-- Reset shader to draw UI elements normally
	love.graphics.setShader()

	--love.graphics.setShader(triangle)

	-- Draw UI or debug info
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print("Black Hole Center: " .. math.floor(center_x) .. ", " .. math.floor(center_y), 10, 10)
	love.graphics.print("Radius: " .. black_hole_radius, 10, 30)
	love.graphics.print("Strength: " .. string.format("%.2f", distortion_strength), 10, 50)
	love.graphics.print("Use arrow keys to adjust radius, Space to reset", 10, 70)
end

function love.keypressed(key)
	if key == "up" then
		black_hole_radius = black_hole_radius + 10
		blackhole_shader:send("radius", black_hole_radius)
	elseif key == "down" then
		black_hole_radius = math.max(10, black_hole_radius - 10)
		blackhole_shader:send("radius", black_hole_radius)
	elseif key == "left" then
		distortion_strength = math.max(0.1, distortion_strength - 0.1)
		blackhole_shader:send("strength", distortion_strength)
	elseif key == "right" then
		distortion_strength = math.min(2.0, distortion_strength + 0.1)
		blackhole_shader:send("strength", distortion_strength)
	elseif key == "space" then
		center_x = love.graphics.getWidth() / 2
		center_y = love.graphics.getHeight() / 2
		black_hole_radius = 150
		distortion_strength = 0.5
		blackhole_shader:send("center_pos", { center_x, center_y })
		blackhole_shader:send("radius", black_hole_radius)
		blackhole_shader:send("strength", distortion_strength)
	elseif key == "escape" then
		love.event.quit()
	elseif key == "f1" then
		w = {
			x = 0,
			y = 0,
			label = "console",
			bella = function()
				print("im a funcion in a table")
			end,
		}
		x = { math.sin(0), math.sin(1), math.sin(2) }
		w[1] = "another field"
		-- add key 1 to table 'w'
		x.f = w
		for _, value in pairs(x.f) do
			print(value)
		end
		w.bella()
		-- add key "f" to table 'x'
		print(w["x"])
		--> 0
		print(w[1])
		--> another field
		print(x.f[1])
		--> another field
		w.x = nil
		-- remove field "x"
	elseif key == "f2" then
		local function reorder_list(list)
			local k = 1    -- Questo è l'indice per la nuova lista "compatta"
			for i = 1, #list do -- Scorre tutta la lista originale
				if list[i] ~= nil then -- Se l'elemento non è nil...
					-- Lo sposta nella posizione k della lista riorganizzata
					list[k] = list[i]
					k = k + 1 -- Passa alla prossima posizione
				end
			end

			-- Riempie la parte finale della lista con nil
			for i = k, #list do
				list[i] = nil
			end

			return list
		end

		-- Esempio di utilizzo
		local a = { 1, 2, nil, 3, nil, 4, 5 }
		local b = reorder_list(a)

		for i = 1, #b do
			print(b[i])
		end
		-- L'output sarà:
		-- 1
		-- 2
		-- 3
		-- 4
		-- 5
	elseif key == "f3" then
		table = {}
		table.x = 10
		x = "bella"

		table[x] = "weeee sto con bella"

		for index, value in pairs(table) do
			print(index .. " " .. value)
		end

		sunday = "monday" -- 1
		monday = "sunday" -- 2
		--[[
            its a bit trick
            but let me explain define two varible
            1 and 2, adn give that a value
            define a table, with a custum entry
                - 1 - name like the variable 1 and give a value
                - 2 - the second entry take the tkey as the value of the first variale
                        and the value equal to the secondo variale
            in the print statment i m gone print
                - 1 - the value of the first entry with the key
                ... so on i undertand it
        ]]
		t = { sunday = "monday", [sunday] = monday }
		print(t.sunday, t[sunday], t[t.sunday])

		table_test = {}
		x = "y"
		table_test[x] = 10
		print(table_test["y"])
		print(table_test.x)
		polyline = {
			color = "blue",
			thickness = 2,
			npoints = 4,
			{ x = 0,   y = 0 },
			{ x = -10, y = 0 },
			{ x = -10, y = 1 },
			{
				x = 0,
				y = 1,
			},
			{ 1, 1, 1, 1, 1, 1, 1, 1, 1 },
		}
		for _, value in ipairs(polyline) do
			print("length table : " .. #value) -- the operator # return the number of element in a table, indices by a
			for key, value in pairs(value) do
				print(key, value)
			end
			if #value == 2 then
				print(value)
			end
		end
	elseif key == "f4" then
		f = function()
			print("hello from f")
		end

		local x = 10
		if x < 100 then
			local f = function()
				print("hello from local f")
			end
			f()
		end
		f()
		math.randomseed(os.time())
		local randomChar = "abcdefghilmnopqrstuvzABCDEFGHILMNOPQRSTUVZ123456789!@#$%^&*()+-[]:'.,:,/~"
		local charTable = {}
		for i = 1, 100 do
			local random = math.random(1, string.len(randomChar))
			local s = string.sub(randomChar, random, random)
			random = math.random(1, string.len(randomChar))
			local keys = string.sub(randomChar, random, random)

			for _ = 1, math.random(1, #randomChar) do
				random = math.random(1, string.len(randomChar))
				local addrandom = string.sub(randomChar, random, random)
				s = s .. addrandom
			end
			s = string.reverse(s)
			local pairToInsert = { key = keys, name = s }
			table.insert(charTable, i, pairToInsert)
		end

		print("before sorting : ")

		for key, value in pairs(charTable) do
			--print(key, value.key, value.name)
		end

		print("after sorting : ")

		table.sort(charTable, function(a, b)
			return #a.name > #b.name
		end)
		for key, value in pairs(charTable) do
			--print(key, value.key, value.name)
		end

		function newCounter()
			local count = ""
			local randomChar = "abcdefghilmnopqrstuvzABCDEFGHILMNOPQRSTUVZ123456789!@#$%^&*()+-[]:'.,:,/~"
			local random = math.random(1, string.len(randomChar))
			local s = string.sub(randomChar, random, random)
			return function()
				-- anonymous function
				count = count .. s
				return count
			end
		end

		c1 = newCounter();
		print(c1())
		print(c1())



		print(os.date("a %A in %B"))
		print(os.date("%d/%m/%Y", 906000490))
		--> a Tuesday in
		local date = os.time()
		local day2year = 365.242
		local sec2hour = 60 * 60
		local sec2day = sec2hour * 24
		local sec2year = sec2day * day2year -- days in a year
		local ril = math.floor(10 / 3)
		print(ril)
		-- seconds in an hour
		-- seconds in a day
		-- seconds in a year
		-- year
		print(math.floor(date / sec2year) + 1970) --> 2015.0
		-- hour (in UTC)
		print(math.floor(date % sec2day / sec2hour)) --> 15
		-- minutes
		print(math.floor(date % sec2hour / 60)) --> 45
		-- seconds
		print(date % 60)                       --> 20

		local N, M = 5, 5
		-- create a N x M matrix initialized to 0
		-- mt[i][j] = 0
		-- mt = { {0, 0, 0, 0, 0},
		--        {0, 0, 0, 0, 0},
		--        {0, 0, 0, 0, 0},
		--        {0, 0, 0, 0, 0},
		--        {0, 0, 0, 0, 0} }
		local mt = {}
		for i = 1, N do
			local row = {}
			mt[i] = row
			for j = 1, M do
				row[j] = 0
			end
		end
	end
end
