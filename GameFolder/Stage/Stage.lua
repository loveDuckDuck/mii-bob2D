Object = require 'libraries/classic/classic'

Stage = Object:extend()

function Stage:new()                                   -- Create new stage object 📝
    print("stage created")                             -- Log stage creation ✅
    self.area = Area(self)                             -- Create an area instance 🗺️
    self.timer = Timer()                               -- Create a timer instance ⏱️

    self.main_canvas = love.graphics.newCanvas(gw, gh) -- Create main canvas object 🖼️
end

function Stage:update(dt) -- Update stage logic here 🕹️
    self.area:update(dt)  -- Update the area too 👍
end

function Stage:draw()                                    -- Drawing stage visuals here 🎨
    love.graphics.setCanvas(self.main_canvas)            -- Set main canvas target 🎯
    love.graphics.clear()                                -- Clear the current frame 🧹
    love.graphics.circle('line', gw / 2, gh / 2, 50)    -- Draw some test circle ⚪
        love.graphics.setLineWidth(5)

    self.area:draw()                                     -- Draw the area now 👀
    love.graphics.setCanvas()                            -- Reset the canvas 🔄

    love.graphics.setColor(1, 1, 1, 1)                   -- New 0-1 range for LÖVE 11.5
    love.graphics.setBlendMode('alpha', 'premultiplied') -- Set blend mode here ⚙️
    local x = (love.graphics.getWidth() - gw * sx) / 2
    local y = (love.graphics.getHeight() - gh * sy) / 2

    love.graphics.draw(self.main_canvas, x, y, 0, sx, sy)

    love.graphics.setBlendMode('alpha') -- Reset the blend mode 🔄
end
