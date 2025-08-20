Object = require 'libraries/classic/classic'

local Area = Object:extend()

function Area:new(room)
    self.room = room
    self.game_objects = {}
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
    if self.world then self.world:update(dt) end
    for i = #self.game_objects, 1, -1 do
        local game_object = self.game_objects[i]
        game_object:update(dt)
        if game_object.dead then table.remove(self.game_objects, i) end
    end
end

function Area:draw()
    if self.world then self.world:draw() end
    for _, game_object in ipairs(self.game_objects) do game_object:draw() end
end

-- the idea behind it is like the add the room to the persistent type
-- @param the game object class

function Area:addGameObject(game_object_type, x, y, opts)
    local opts = opts or {}

    print(game_object_type)
    local game_object = _G[game_object_type](self, x or 0, y or 0, opts)
    print(game_object)

    table.insert(self.game_objects, game_object)
    return game_object
end

function Area:addPhysicsWorld()
    self.world = Physics.newWorld(0, 0, true) -- it fall down if i set the Y to 512 crazy
    
end

return Area
