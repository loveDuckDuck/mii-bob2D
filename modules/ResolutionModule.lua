ResolutionModule = Object:extend()


function ResolutionModule:new(console, y)
    self.console = console
    self.y = y

    self.console:addLine(0.02, 'Available resolutions: ')
    self.console:addLine(0.04, '    640x360')
    self.console:addLine(0.06, '    1280x720')
    self.console:addLine(0.08, '    1366x768')
    self.console:addLine(0.10, '    1600x900')
    self.console:addLine(0.12, '    1920x1080')
    
    self.y = y
    self.h = 6 * self.console.font:getHeight()

    self.selection_index = 1
    self.selection_widths = {
        { self.console.font:getWidth('640x360'),   640,  360 },
        { self.console.font:getWidth('1280x720'),  1280, 720 },
        { self.console.font:getWidth('1366x768'),  1366, 768 },
        { self.console.font:getWidth('1600x900'),  1600, 900 },
        { self.console.font:getWidth('1920x1080'), 1920, 1080 }
    }
    self.console.timer:after(0.01 + self.selection_index * 0.02, function()
        self.active = true
    end)
end

function ResolutionModule:update(dt)
    if not self.active then return end
    if GInput:pressed("shootup") then
        self.selection_index = self.selection_index - 1
        if self.selection_index < 1 then self.selection_index = #self.selection_widths end
    end

    if GInput:pressed("shootdown") then
        self.selection_index = self.selection_index + 1
        if self.selection_index > #self.selection_widths then self.selection_index = 1 end
    end
    if GInput:pressed("enter") then
        self.active = false
        print('Selected resolution: ' .. self.selection_index)
        resizeWidthHeight(self.selection_widths[self.selection_index][2], self.selection_widths[self.selection_index][3])
        self.console:addLine(0.02, '')
        self.console:addInputLine(0.04)
    end
end

function ResolutionModule:draw()
    if not self.active then return end

    local width = self.selection_widths[self.selection_index][1]
    local r, g, b = unpack(G_default_color)
    love.graphics.setColor(r, g, b, 27)
    local x_offset = self.console.font:getWidth('    ')
    love.graphics.rectangle('fill', 8 + x_offset - 2, self.y + self.selection_index * 12, width + 4,
        self.console.font:getHeight())
    love.graphics.setColor(r, g, b, 1)
end
