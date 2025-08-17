Object = require'libraries/classic/classic'

local GameObject = Object:extend() -- Extend the object

function GameObject:new(area, x, y, opts) -- Constructor function 🛠️
    local opts = opts or {} -- Use opts or empty table
    if opts then for k, v in pairs(opts) do self[k] = v end end -- Copy options ✍️

    self.area = area -- Set the area
    self.x, self.y = x, y -- Set coordinates
    self.id = UUID() -- Generate a unique id
    self.creation_time = love.timer.getTime() -- Get creation time ⏳
    self.timer = Timer() -- Initialize the timer
    self.dead = false -- Not dead yet 😇
end

function GameObject:update(dt) -- Update function 🔄
    if self.timer then self.timer:update(dt) end -- Update the timer if any
end

function GameObject:draw() -- Draw function 🎨

end

return GameObject -- Return the GameObject class