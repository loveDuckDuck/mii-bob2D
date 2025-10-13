Area = Object:extend()

function Area:new(room)
	self.room = room
	self.game_objects = {}
	self.gameObjectType = {}
end

--[[
The # operator in Lua returns the length of a
sequence (usually the highest integer index in
an array-like table).

for var = start, stop, step do
    -- loop body
end
]]

function Area:update(dt)
	if self.world then
		self.world:update(dt)
	end
	for i = #self.game_objects, 1, -1 do
		local game_object = self.game_objects[i]
		game_object:update(dt)
		if game_object.dead then
			print("Rremoved : " ..
				self.gameObjectType[i] .. " | Total GameObjects: " .. #self.game_objects)
			game_object:destroy()
			table.remove(self.game_objects, i)
		end
	end
end

function Area:draw()
	if self.world then
		self.world:draw()
	end
	table.sort(self.game_objects, function(a, b)
		if a.layer == b.layer then
			return a.creation_time < b.creation_time
		else
			return a.layer < b.layer
		end
	end)

	for _, game_object in ipairs(self.game_objects) do
		game_object:draw()
	end
end

-- the idea behind it is like the add the room to the persistent type
-- @param the game object class

function Area:addGameObject(game_object_type, x, y, opts)
	local opts = opts or {}

	local game_object = _G[game_object_type](self, x or 0, y or 0, opts)

	table.insert(self.game_objects, game_object)
	table.insert(self.gameObjectType, game_object_type)
	print("Added GameObject of type: " .. game_object_type .. " | Total GameObjects: " .. #self.game_objects)
	return game_object
end

function Area:addPhysicsWorld()
	self.world = Physics.newWorld(0, 0, true) -- it fall down if i set the Y to 512 crazy
end

--[[
Cycle on my area and destroy all the object thath i had referecend on it
after that shat remove the table object and add a new own
if I got a world physic add to it set it to null and destroy
]]

function Area:destroy()
	for i = #self.game_objects, 1, -1 do
		local game_object = self.game_objects[i]
		print("Destroy : " .. self.gameObjectType[i])
		game_object:destroy()
		table.remove(self.game_objects, i)
	end
	self.game_objects = {}

	if self.world then
		self.world:destroy()
		self.world = nil
	end
end

--- Returns a table containing all game objects that satisfy the given filter function.
-- @param filter A function that takes a game object as an argument and returns true
-- if the object should be included.
-- @return table A table of game objects that match the filter criteria.
function Area:getAllGameObjectsThat(filter)
	local objectFiltered = {}
	for _, value in ipairs(self.game_objects) do
		if filter(value) then
			table.insert(objectFiltered, value)
		end
	end
	return objectFiltered
end
