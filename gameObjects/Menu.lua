Menu = GameObject:extend()

function Menu:new(area, x, y, opts)

    Menu.super.new(self, area, x, y, opts)
    self.options = { "Start Game", "Options", "Exit" }
    self.selected_index = 1
    self.r = "restart"
    self.q = "quit"
    self.h = 0
    self.w = GW * SX 



end
function Menu:update(dt)
	Menu.super.update(self, dt)
end

function Menu:draw()
    love.graphics.setColor(GDefaultColor)
    love.graphics.rectangle("fill", 0, 0, GW * SX, GH * SY)

    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("Main Menu", 0, GH * SY / 4, GW * SX, "center")

    for i, option in ipairs(self.options) do
        if i == self.selected_index then
            love.graphics.setColor(1, 0, 0)
        else
            love.graphics.setColor(0, 0, 0)
        end
        love.graphics.printf(option, 0, GH * SY / 2 + (i - 1) * 30, GW * SX, "center")
    end

    love.graphics.setColor(GDefaultColor)
end

function Menu:destroy()
    Menu.super.destroy(self)
end