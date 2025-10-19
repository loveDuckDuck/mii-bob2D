Director = Object:extend()

function Director:new(stage, player)
	self.stage = stage
	self.player = player
	self.difficulty = 1
	self.round_duration = 22
	self.round_timer = 0
	self.timer = Timer()
	if not self.stage then
		error("Director needs a stage!")
	end

	if not self.stage.area then
		error("Director needs a stage with an area!")
	end
	--[[
    Initializes the `difficulty_to_points` table, mapping difficulty levels to point values.
    - Starts with difficulty level 1 assigned 16 points.
    - For each difficulty level from 2 to 1024 (incremented by 4):
        - Level `i` is assigned 8 points more than the previous level.
        - Level `i+1` is assigned the same points as level `i`.
        - Level `i+2` is assigned the floor of level `i+1`'s points divided by 1.5.
        - Level `i+3` is assigned the floor of level `i+2`'s points multiplied by 2.
    This creates a non-linear progression of points based on difficulty.
    ]]
	self.difficulty_to_points = {}
	self.difficulty_to_points[1] = 16
	for i = 2, 1024, 4 do
		self.difficulty_to_points[i] = self.difficulty_to_points[i - 1] + 8
		self.difficulty_to_points[i + 1] = self.difficulty_to_points[i]
		self.difficulty_to_points[i + 2] = math.floor(self.difficulty_to_points[i + 1] / 1.5)
		self.difficulty_to_points[i + 3] = math.floor(self.difficulty_to_points[i + 2] * 2)
	end

	self.enemy_to_points = {
		["Rock"] = 1,
		["Shooter"] = 2,
	}

	self.resource_to_points = {
		["ResourceCoin"] = 1,
		["BoostCoin"] = 2,
		["Ammo"] = 3,
	}

	self.resource_spawn_chances = {}
	for i = 1, 1024 do
		self.resource_spawn_chances[i] = CreateChanceList(
			{ "Ammo", love.math.random(2, 8) },
			{ "BoostCoin", love.math.random(1, 4) }
		)
	end

	self.enemy_spawn_chances = {
		[1] = CreateChanceList({ "Rock", 1 }),
		[2] = CreateChanceList({ "Rock", 8 }, { "Shooter", 4 }),
		[3] = CreateChanceList({ "Rock", 8 }, { "Shooter", 8 }),
		[4] = CreateChanceList({ "Rock", 4 }, { "Shooter", 8 }),
	}
	for i = 5, 1024 do
		self.enemy_spawn_chances[i] = CreateChanceList(
			{ "Rock", love.math.random(2, 12) },
			{ "Shooter", love.math.random(2, 12) }
		)
	end

	self:setEnemySpawnsForThisRound()
	self:setRecourceSpawnsForThisRound()
end

function Director:setEnemySpawnsForThisRound()
	print("Setting enemy spawns for round with difficulty " .. self.difficulty)
	local points = self.difficulty_to_points[self.difficulty]

	-- Find enemies
	local enemy_list = {}
	while points > 0 do
		local enemy = self.enemy_spawn_chances[self.difficulty]:next()
		points = points - self.enemy_to_points[enemy]
		table.insert(enemy_list, enemy)
	end
	-- Find enemies spawn times
	local enemy_spawn_times = {}
	for i = 1, #enemy_list do
		enemy_spawn_times[i] = math.customRandom(0, self.round_duration)
	end

	table.sort(enemy_spawn_times, function(a, b)
		return a < b
	end)

	-- Set spawn enemy timer
	for i = 1, #enemy_spawn_times do
		self.timer:after(enemy_spawn_times[i], function()
			self.stage.area:addGameObject(
				enemy_list[i],
				math.customRandom(self.player.x - GW / 2, self.player.x + GW / 2),
				math.customRandom(self.player.y - GH / 2, self.player.y + GH / 2)
			)
		end)
	end
end

function Director:update(dt)
	if self.player then
		self.round_timer = self.round_timer + dt
		if self.timer then
			self.timer:update(dt)
		end -- Update the timer if any

		if self.round_timer > self.round_duration / self.player.multiplierManager.enemy_spawn_rate_multiplier then
			self.round_timer = 0
			self.difficulty = self.difficulty + 1
			self:setEnemySpawnsForThisRound()
			self:setRecourceSpawnsForThisRound()
			print("New round! Difficulty: " .. self.difficulty)
		end
	end
end

function Director:setRecourceSpawnsForThisRound()
	local points = self.difficulty_to_points[self.difficulty]

	-- Find enemies
	local resource_list = {}
	while points > 0 do
		local resource = self.resource_spawn_chances[self.difficulty]:next()
		points = points - self.resource_to_points[resource]
		table.insert(resource_list, resource)
	end
	-- Find enemies spawn times
	local resource_spawn_times = {}
	for i = 1, #resource_list do
		resource_spawn_times[i] = math.customRandom(0, self.round_duration)
	end

	table.sort(resource_spawn_times, function(a, b)
		return a < b
	end)

	-- Set spawn resource timer
	for i = 1, #resource_spawn_times do
		self.timer:after(resource_spawn_times[i], function()
			self.stage.area:addGameObject(
				resource_list[i],
				math.customRandom(self.player.x - GW / 2, self.player.x + GW / 2),
				math.customRandom(self.player.y - GH / 2, self.player.y + GH / 2)
			)
		end)
	end
end

function Director:destroy()
	self.timer:destroy()
	table.clear(self)
end
