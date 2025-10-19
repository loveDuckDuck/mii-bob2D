Game = Object:extend()

function Game:init()
    self.memoryInit = collectgarbage("count") * 1024
    self.memoryUsed = self.memoryInit
    self.global_type_table = nil
    self.new = 0
    self.diff = 0
    print(string.format("initial memory usage (%d bytes)", self.memoryInit))
end

function Game:update(dt)
    self:memoryCheck()
end

function Game:draw()
    -- -- Draw game objects and UI elements here
    love.graphics.print("Game is running : ", 0, 10)
--    self:DrawGarbageCollector()
    -- fine grained memory changes
    if self.diff > 0 then
         love.graphics.print(string.format("memory use\t+%dKB (%d bytes)", self.diff / 1024, self.new - self.memoryInit),0, 30)
    elseif self.diff < 0 then
         love.graphics.print(string.format("memory free\t%dKB (%d bytes)", self.diff / 1024, self.new - self.memoryInit), 0, 30)
    end

    love.graphics.print(string.format("current memory usage: %.2f KB", self.new/1024), 0, 50)
    love.graphics.print(string.format("current memory usage: %.2f MB", self.new/1024/1024), 0, 70)


end

function Game:count_all(f)
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

function Game:type_count()
    local counts = {}
    local enumerate = function(o)
        local t = self:type_name(o)
        counts[t] = (counts[t] or 0) + 1
    end
    self:count_all(enumerate)
    return counts
end

function Game:type_name(o)
    if self.global_type_table == nil then
        self.global_type_table = {}
        for k, v in pairs(_G) do
            self.global_type_table[v] = k
        end
        self.global_type_table[0] = "table"
    end
    return self.global_type_table[getmetatable(o) or 0] or "Unknown"
end

function Game:type_count_and_print_unknowns()
    local counts = {}
    -- Table to specifically store objects classified as "Unknown"
    local unknown_objects = {}

    local enumerate = function(o)
        local t = self:type_name(o)

        -- 1. Increment the count
        counts[t] = (counts[t] or 0) + 1

        -- 2. Store the unknown object
        if t == "Unknown" then
            table.insert(unknown_objects, o)
        end
    end

    self:count_all(enumerate)

    -- Print the unknown objects after traversal is complete
    print("\n--- Unknown Objects Found ---")
    for i, obj in ipairs(unknown_objects) do
        local obj_type = type(obj)
        local obj_id = tostring(obj) -- Unique identifier/address (good for debugging)

        -- Attempt to print a useful representation
        if obj_type == "table" then
            -- Note: Printing a table directly shows its address, not its contents.
            print(string.format("Unknown #%d: Type: %s, Address: %s, Keys: %d",
                i, obj_type, obj_id, select(2, next(obj)) ~= nil and #obj > 0 and #obj or 0))
        elseif obj_type == "userdata" then
            print(string.format("Unknown #%d: Type: %s, Address: %s",
                i, obj_type, obj_id))
        else
            -- Should not happen with current count_all logic, but safe to include
            print(string.format("Unknown #%d: Type: %s, Value: %s",
                i, obj_type, tostring(obj)))
        end
    end
    print("-------------------------------\n")

    return counts
end

function Game:DrawGarbageCollector()
    love.graphics.setColor(0, 1, 0, 1)
    -- Print the header for object counts
    love.graphics.print("Object count:", 0, 100)

    local counts = self:type_count()
    local y_offset = 120
    -- Loop through the counts and print each on a new line
    counts = table.counterSort(counts)
    for x = 1, #counts do
        love.graphics.print(counts[x].key .. ": " .. counts[x].value, 0, y_offset)
        y_offset = y_offset + 20 -- Increment the y-coordinate for the next line
    end

    love.graphics.print(GW .. " : " .. GH, 0, y_offset)
    y_offset = y_offset + 20

    love.graphics.setColor(1, 1, 1, 1)
end

function Game:memoryCheck()
    self.new = collectgarbage("count") * 1024
    self.diff = self.new - self.memoryUsed

    -- still making large numbers of allocations
    if self.diff > self.memoryInit then
        self.memoryUsed = self.new
        return
    end

    -- fine grained memory changes
    if self.diff > 0 then
      --  print(string.format("memory use\t+%dKB (%d bytes)", self.diff / 1024, self.new - self.memoryInit))
    elseif self.diff < 0 then
     --   print(string.format("memory free\t%dKB (%d bytes)", self.diff / 1024, self.new - self.memoryInit))
    end

    self.memoryUsed = self.new
end
