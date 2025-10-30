Menu = GameObject:extend()

function Menu:new(area, x, y, opts)
    Menu.super.new(self, area, x, y, opts)
    self.options = { "Z -> restart game", "X -> resize windows", "escape -> quit" }
    self.selected_index = 1
    self.h = 0
    self.w = GW * SX
    self.resolutionIndex = 2
    self.firstPressEscape = false
    self.resolutions = {
        { width = 640,  height = 360 },
        { width = 1280, height = 720 },
        { width = 1366, height = 768 },
        { width = 1440, height = 900 },
        { width = 1620, height = 900 },
        { width = 1920, height = 1080 },
    }
end

function Menu:update(dt)
    Menu.super.update(self, dt)

    if GInput:pressed("restart") then
        print('Restarting game')
    end
    if GInput:pressed("quit") then
        print('Quitting game')
        QuitFGame()
    end

    if GInput:pressed("resizeWindow") then
        print('Changing resolution')
        self.resolutionIndex = self.resolutionIndex + 1
        if self.resolutionIndex > #self.resolutions then
            self.resolutionIndex = 1
        end
        local res = self.resolutions[self.resolutionIndex]
        resizeWidthHeight(res.width, res.height)
    end
end

function Menu:draw()
    for index, value in ipairs(self.options) do
        love.graphics.print(
            value,
            GW / 2 -GFont:getWidth(value),
            index * 30,
            0,
            SX,
            SY
        )
    end
end

function Menu:destroy()
    Menu.super.destroy(self)
end
