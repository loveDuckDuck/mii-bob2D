Object = require 'libraries/classic/classic'

-- in objects/Test.lua
Rectangle = Object:extend()

function Rectangle:new(height, width, x,y)
    self.height, self.width = height, width
    self.x,self.y = x,y
    self.creation_time = love.timer.getTime()
end

function Rectangle:update(dt)

end

function Rectangle:draw()
    love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)
end