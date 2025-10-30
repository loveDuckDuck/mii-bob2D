Console = Object:extend()

function Console:new()
    self.timer = Timer()
    self.main_canvas = love.graphics.newCanvas(GW, GH)
    self.lines = {}

    self.modules = {}
    self.line_y = 8
    self.font = GFont
    self.base_input_text = { '[', GSkillPointColor, 'root', GDefaultColor, ']arch~ :  ' }
    self:addInputLine(0.25)
    self.input_text = {}
    self.timer_delete_counter = 0

    self.cursor_visible = true
    self.timer:every('cursor', 0.5, function()
        self.cursor_visible = not self.cursor_visible
    end)
    GCamera:lookAt(GW / 2, GH / 2)
	GInput:unbindAll()

    GInput:bind("return", "enter")
	GInput:bind("backspace", "delete")

end

function Console:update(dt) -- Update stage logic here 🕹️
    GCamera:update(dt)
    self.timer:update(dt)
    for _, module in ipairs(self.modules) do module:update(dt) end
    if self.inputting then
        if GInput:pressed("enter") then
            local input_text = ''
            for _, character in ipairs(self.input_text) do
                input_text = input_text .. character
            end
            self.line_y = self.line_y + 12

            self.input_text = {}
            if input_text == 'resolution' then
                table.insert(self.modules, ResolutionModule(self, self.line_y))
                self.inputting = false
            else
                self:addInputLine(0.05)
            end
        end
        if GInput:down("delete") then
            self.timer_delete_counter = self.timer_delete_counter + dt

            if self.timer_delete_counter > 0.2 then
                table.remove(self.input_text, #self.input_text)
                self:updateText()
                self.timer_delete_counter = 0
            end
        end
    end
end

function Console:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
    GCamera:attach(0, 0, GW, GH)

    for _, line in ipairs(self.lines) do
        love.graphics.draw(line.text, line.x, line.y)
    end
    if self.inputting and self.cursor_visible then
        local r, g, b = unpack(GDefaultColor)
        love.graphics.setColor(r, g, b, 96)
        local input_text = ''
        for _, character in ipairs(self.input_text) do input_text = input_text .. character end
        local x = 8 + self.font:getWidth('[root]arch~ :  ' .. input_text)
        love.graphics.rectangle('fill', x, self.lines[#self.lines].y,
            self.font:getWidth('w'), self.font:getHeight())
        love.graphics.setColor(r, g, b, 255)
    end
    for _, module in ipairs(self.modules) do module:draw() end
    GCamera:detach()
    love.graphics.setCanvas()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, SX, SY)
    love.graphics.setBlendMode('alpha')
end

function Console:addLine(delay, text)
    self.timer:after(delay, function()
        table.insert(self.lines, {
            x = 8,
            y = self.line_y,
            text = love.graphics.newText(self.font, text)
        })
        self.line_y = self.line_y + 12
    end)
end

function Console:addInputLine(delay)
    self.timer:after(delay, function()
        table.insert(self.lines, {
            x = 8,
            y = self.line_y,
            text = love.graphics.newText(self.font, self.base_input_text)
        })
        self.line_y = self.line_y + 12
        self.inputting = true
    end)

    print(#self.lines)
end

function Console:textinput(t)
    if self.inputting then
        table.insert(self.input_text, t)
        self:updateText()
    end
end

function Console:updateText()
    local base_input_text = table.shallow_copy(self.base_input_text)
    local input_text = ''
    for _, character in ipairs(self.input_text) do input_text = input_text .. character end
    table.insert(base_input_text, input_text)
    self.lines[#self.lines].text:set(base_input_text)
end


function Console:destroy()
    self.timer:destroy()
end