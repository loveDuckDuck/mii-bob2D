function UUID()
	local fn = function(x)
		local r = math.random(16) - 1
		r = (x == "x") and (r + 1) or (r % 4) + 9
		return ("0123456789abcdef"):sub(r, r)
	end
	return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end

function UpdateScale()
	local window_width = love.graphics.getWidth()
	local window_height = love.graphics.getHeight()

	-- Calculate scale to fit the game area in the window
	sx = gw / window_width -- If window is 960px and gw=480px, sx = 0.5 (half size)
	sy = gh / window_height -- If window is 540px and gh=270px, sy = 0.5 (half size)

	gw = window_width * sx
	gh = window_height * sy

	print("Scale updated: sx =", sx, "sy =", sy)
	-- Optional: Use uniform scaling (same scale for both axes)
	-- local scale = math.min(sx, sy)
	-- sx, sy = scale, scale
end

function math.customRandom(min, max)
	local min, max = min or 0, max or 1
	return (min > max and (love.math.random() * (min - max) + max)) or (love.math.random() * (max - min) + min)
end

function count_all(f)
	local seen = {}
	local count_table
	count_table = function(t)
		if seen[t] then
			return
		end
		f(t)
		seen[t] = true
		for k, v in pairs(t) do
			if type(v) == "table" then
				count_table(v)
			elseif type(v) == "userdata" then
				f(v)
			end
		end
	end
	count_table(_G)
end

function type_count()
	local counts = {}
	local enumerate = function(o)
		local t = type_name(o)
		counts[t] = (counts[t] or 0) + 1
	end
	count_all(enumerate)
	return counts
end

global_type_table = nil
function type_name(o)
	if global_type_table == nil then
		global_type_table = {}
		for k, v in pairs(_G) do
			global_type_table[v] = k
		end
		global_type_table[0] = "table"
	end
	return global_type_table[getmetatable(o) or 0] or "Unknown"
end

function DrawGarbageCollector()
	love.graphics.setColor(0, 1, 0, 1)
	love.graphics.print("Before collection: " .. collectgarbage("count") / 1024, 0, 0)
	collectgarbage()
	love.graphics.print("After collection: " .. collectgarbage("count") / 1024, 0, 20)

	-- Print the header for object counts
	love.graphics.print("Object count:", 0, 40)

	local counts = type_count()
	local y_offset = 60

	-- Loop through the counts and print each on a new line
	for k, v in pairs(counts) do
		love.graphics.print(k .. ": " .. v, 0, y_offset)
		y_offset = y_offset + 20 -- Increment the y-coordinate for the next line
	end

	love.graphics.print(gw .. " : " .. gh, 0, y_offset)
	y_offset = y_offset + 20

	love.graphics.setColor(1, 1, 1, 1)
end

function PushRotate(x, y, r)
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(r or 0)
	love.graphics.scale(sx or 1, sy or sx or 1)
	love.graphics.translate(-x, -y)
end

function PushRotateScale(x, y, r, sx, sy)
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(r or 0)
	love.graphics.scale(sx or 1, sy or sx or 1)
	love.graphics.translate(-x, -y)
end

function ShortestRotationPath(currentAngle, targetAngle)
	-- Normalize angles to [-π, π] range
	local function normalizeAngle(angle)
		while angle > math.pi do
			angle = angle - 2 * math.pi
		end
		while angle < -math.pi do
			angle = angle + 2 * math.pi
		end
		return angle
	end

	-- Calculate the difference
	local diff = normalizeAngle(targetAngle - currentAngle)

	return diff
end

function RotateTowards(player, targetAngle, dt)
	local rotationDiff = ShortestRotationPath(player.rotation, targetAngle)

	-- If we're close enough, snap to target
	if math.abs(rotationDiff) < 0.1 then
		player.rotation = targetAngle
	else
		-- Rotate towards target at rotationVelocity speed
		local rotationStep = player.rotationVelocity * dt
		if rotationDiff > 0 then
			player.rotation = player.rotation + math.min(rotationStep, rotationDiff)
		else
			player.rotation = player.rotation + math.max(-rotationStep, rotationDiff)
		end
	end
end

function love.quit()
	if not readyToQuit then
		print("We are not ready to quit yet!")
		readyToQuit = true
		return true
	else
		print("Thanks for playing. Please play again soon!")
		return false
	end
end

function DeleteEveryThing()
	print("DeleteEveryThing")
	love.event.quit()
end

--[[
    -- Use:
    local dy = target.y - self.y
    local dx = target.x - self.x
    local angle = my_atan2(dy, dx)
    i need to use this because atan2 it deprecated
    so i need to calculate manually the quadranct, becuase atan, is not safe with x = 0 and
    return only anglese in Q1 and Q4
        y
        ↑
    Q2  |  Q1     atan2 handles: Q1, Q2, Q3, Q4
    ------+------  atan handles:   Q1, Q4 only (and maps Q2,Q3 to Q4,Q1)
    Q3  |  Q4

    ]]

function GlobalAtan2(y, x)
	if x > 0 then
		return math.atan(y / x)
	elseif x < 0 then
		return math.atan(y / x) + math.pi * (y >= 0 and 1 or -1)
	elseif y > 0 then
		return math.pi / 2
	elseif y < 0 then
		return -math.pi / 2
	else
		return 0 -- x = 0, y = 0 (undefined)
	end
end

function table.random(t)
	return t[love.math.random(1, #t)]
end

function table.count(t)
	local count = 0
	for _, _ in pairs(t) do
		count = count + 1
	end
	return count
end

function table.randomResource(t)
	if next(t) == nil then
		return nil
	end
	local keys = {}
	for key in pairs(t) do
		table.insert(keys, key)
	end
	local randomIndex = math.random(1, #keys)
	-- Restituisci la risorsa corrispondente alla chiave casuale
	return t[keys[randomIndex]]
end

function CreateIrregularPolygon(size, point_amount)
	local point_amount = point_amount or 8
	local points = {}
	for i = 1, point_amount do
		local angle_interval = 2 * math.pi / point_amount
		local distance = size + math.customRandom(-size / 4, size / 4)
		local angle = (i - 1) * angle_interval + math.customRandom(-angle_interval / 4, angle_interval / 4)
		table.insert(points, distance * math.cos(angle))
		table.insert(points, distance * math.sin(angle))
	end
	return points
end

--- Creates a chance list object that allows random selection of items based on their defined chances.
-- Each chance definition is a table of the form {item, chance}, where 'item' is any value and 'chance' is a positive integer
-- representing how many times the item should appear in the internal chance list.
-- The returned object has a `next` method that randomly selects and removes an item from the chance list,
-- rebuilding the list from the definitions when it becomes empty.
-- @param ... Variable number of chance definitions, each as {item, chance}
-- @return table Chance list object with a `next` method for random selection
function CreateChanceList(...)
	return {
		chance_list = {},
		chance_definitions = { ... },
		next = function(self)
			if #self.chance_list == 0 then
				for _, chance_definition in ipairs(self.chance_definitions) do
					-- chance_definition[1] = item
					-- chance_definition[2] = how many times to include it
					for i = 1, chance_definition[2] do
						table.insert(self.chance_list, chance_definition[1])
					end
				end
			end
			-- pick a random item from the list and remove it
			return table.remove(self.chance_list, love.math.random(1, #self.chance_list))
		end,
	}
end

--- A general-purpose linear interpolation function.
-- It finds a value that is a certain fraction between two other values.
-- @param a The starting value.
-- @param b The ending value.
-- @param t The interpolation amount (a value between 0.0 and 1.0).
-- @return The interpolated value.
function Lerp(a, b, t)
	return a + (b - a) * t
end

--- Interpolates between two colors.
-- Both colors should be tables with 'r', 'g', and 'b' components (and optionally 'a').
-- The components should be numbers, typically between 0.0 and 1.0.
-- @param color1 The starting color table (e.g., {r=1, g=1, b=0}).
-- @param color2 The ending color table (e.g., {r=0, g=0, b=1}).
-- @param amount A number between 0.0 and 1.0 that represents the mix.
--               0.0 will return color1, 1.0 will return color2,
--               and 0.5 will return a color exactly halfway between them.
-- @return A new color table with the interpolated r, g, b, and a values.
function InterpolateColor(color1, color2, amount)
	-- Ensure the amount is clamped between 0 and 1 to prevent invalid color values.
	local t = math.max(0, math.min(1, amount or 0))

	-- Ensure the input tables are valid
	if not color1 or not color2 or not color1[1] or not color2[1] then
		error("Invalid color tables provided for interpolation.")
		return
	end

	local new_color = {
		math.truncate(Lerp(color1[1], color2[1], t), 4),
		math.truncate(Lerp(color1[2], color2[2], t), 4),
		math.truncate(Lerp(color1[3], color2[3], t), 4),
	}

	-- Also interpolate the alpha channel if it exists in both colors
	if color1[4] and color2[4] then
		new_color[4] = Lerp(color1[4], color2[4], t)
	end

	return new_color
end

function GlobalDistance(x1, y1, x2, y2)
	return math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
end

function math.truncate(number, decimalPlaces)
	local multiplier = 10 ^ decimalPlaces
	return math.floor(number * multiplier) / multiplier
end

function Lenght(table)
	local count = 0
	for _ in pairs(table) do
		count = count + 1
	end
	return count
end

function table.keys(table)
	local keyset = {}
	local n = 0

	for k, v in pairs(table) do
		n = n + 1
		keyset[n] = k
	end
	return keyset
end

function table.merge(t1, t2)
	local new_table = {}
	for k, v in pairs(t2) do
		new_table[k] = v
	end
	for k, v in pairs(t1) do
		new_table[k] = v
	end
	return new_table
end

function table.print(t)
	for key, value in pairs(t) do
		print(key, value)
	end
end

function table.printArray(t)
	for key, value in pairs(t) do
		print(key, value)
	end
end

-- Returns a random angle between angle1 and angle2 (in radians)
function math.randomAngle(angle1, angle2)
    -- normalize order so min < max
    local minAngle = math.min(angle1, angle2)
    local maxAngle = math.max(angle1, angle2)

    -- pick a random number in that range
    return minAngle + (maxAngle - minAngle) * love.math.random()
end
