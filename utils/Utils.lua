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
	SX = GW / window_width -- If window is 960px and GW=480px, SX = 0.5 (half size)
	SY = GH / window_height -- If window is 540px and GH=270px, SY = 0.5 (half size)

	GW = window_width * SX
	GH = window_height * SY

	print("Scale updated: SX =", SX, "SY =", SY)
	-- Optional: Use uniform scaling (same scale for both axes)
	-- local scale = math.min(SX, SY)
	-- SX, SY = scale, scale
end

function math.customRandom(min, max)
	local min, max = min or 0, max or 1
	return (min > max and (love.math.random() * (min - max) + max)) or (love.math.random() * (max - min) + min)
end

function table.counterSort(t)
	local a = {}
	for k, v in pairs(t) do
		table.insert(a, { key = k, value = v })
	end

	table.sort(a, function(x, y) return x.value > y.value end)
	return a
end

function table.pairsByKeys(t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
	table.sort(a)

	local i = 0          -- iterator variable

	local iter = function() -- iterator function
		i = i + 1
		if a[i] == nil then
			return nil
		else
			return a[i], t[a[i]]
		end
	end

	return iter
end

function PushRotate(x, y, r)
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(r or 0)
	love.graphics.scale(SX or 1, SY or SX or 1)
	love.graphics.translate(-x, -y)
end

function PushRotateScale(x, y, r, SX, SY)
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(r or 0)
	love.graphics.scale(SX or 1, SY or SX or 1)
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

function Slow(amount, duration)
	slow = amount
	GTimer:tween("Slow", duration, _G, { slow = 1 }, "in-out-cubic")
end

function math.threeRamdon()
	local r = { math.random(0.0, 1.0), math.random(0.0, 1.0), math.random(0.0, 1.0) }
	return r
end

function table.shallow_copy(t)
	local t2 = {}
	for k, v in pairs(t) do
		t2[k] = v
	end
	return t2
end

function math.miFloor(number)
	return math.floor(number * 100 + 0.5) / 100
end

function ReturnValuePercentage(value, percentage, probability)
	return math.miFloor(value + (probability < 50 and (1) or (-1)) * (value * percentage))
end

function table.clear(t)
	for key, value in pairs(t) do
		t[key] = nil
	end
end
