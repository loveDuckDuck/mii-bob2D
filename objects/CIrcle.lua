Object = require 'libraries/classic/classic'

-- in objects/Test.lua
Circle = Object:extend()


function Circle:new(x, y, radius)
    -- how to initialize in lua
    -- self.x, self.y, self.radius = x, y, radius
    self.x = x
    self.y = y
    self.radius = radius
    self.creation_time = love.timer.getTime()
end

function Circle:update(dt)

end

function Circle:draw()
    love.graphics.circle( "fill",self.x, self.y, self.radius )
end
