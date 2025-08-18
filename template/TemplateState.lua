TemplateState = Object:extend()

function TemplateState:new() -- Constructor function
    print("TemplateState created") -- State creation message
    self.area = Area() -- Create game area
    self.timer = Timer() -- Create game timer
    --self.area:addGameObject('GameObject') -- Add game object?

end

function TemplateState:update(dt) -- Update game logic
    self.area:update(dt) -- Update the game area
end

function TemplateState:draw() -- Draw game visuals
    self.area:draw() -- Draw the game area
end