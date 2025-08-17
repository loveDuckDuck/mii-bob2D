Object = require 'libraries/classic/classic'
local Rectangle = require 'objects/Rectangle'
-- in objects/Test.lua
RectangleRoom = Object:extend()


function RectangleRoom:new()
    self.rectangles = {} -- <--- initialize your circles table
    self.type = 'RectangleRoom'

    self.creation_time = love.timer.getTime()
end

function RectangleRoom:update(dt)
    if (next(self.rectangles) ~= nil) then
        for i, fruit in pairs(self.rectangles) do
            fruit:update(dt)
        end
    end
end

function RectangleRoom:addRectangle(heigth, width, x, y, color)
    table.insert(self.rectangles, Rectangle(heigth, width, x, y, color))
end

function RectangleRoom:draw()
    if (next(self.rectangles) ~= nil) then
        for i, fruit in pairs(self.rectangles) do
            fruit:draw()
        end
    end
end
