
TemplateState = Object:extend()

function TemplateState:new()
    print("TemplateState created")
    self.area = Area()
    self.timer = Timer()
    --self.area:addGameObject('GameObject')

end

function TemplateState:update(dt)
    self.area:update(dt)
end

function TemplateState:draw()
    self.area:draw()
end
