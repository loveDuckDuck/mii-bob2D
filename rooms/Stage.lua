Stage = Object:extend()

function Stage:new()
    print("stage created")
    self.area = Area()
    self.timer = Timer()
    self.area:addGameObject('CircleGameObject',
        love.math.random(0, love.graphics.getWidth()),
        love.math.random(0, love.graphics.getHeight()))
end

function Stage:update(dt)
    self.area:update(dt)
end

function Stage:draw()
    self.area:draw()
end
