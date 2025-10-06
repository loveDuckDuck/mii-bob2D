Console = Object:extend()

function Console:new()
    self.timer = Timer()
    self.lines = {}
    self.line_y = 8
    self.font = Font
    self.base_input_text = { '[', G_skill_point_color, 'root', G_default_color, ']arch~ : ' }
    GCamera:lookAt(GW / 2, GH / 2)
    self:addLine(1, { "test", G_boost_color, "test" })
    self:addInputLine(2)
    self.input_text = {}
    self.timer_delete_counter = 0

    self.cursor_visible = true
    self.timer:every('cursor', 0.5, function()
        self.cursor_visible = not self.cursor_visible
    end)
end

function Console:update(dt) -- Update stage logic here 🕹️
    GCamera:lockPosition(dt, GW / 2, GH / 2)
    GCamera:update(dt)
    self.timer:update(dt)
    if self.inputting then
        if GInput:pressed("enter") then
            self.inputting = false
            -- Run command based on the contents of input_text here
            self.input_text = {}
        end
        if GInput:down("space") then
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
    for _, line in ipairs(self.lines) do
        love.graphics.draw(line.text, line.x, line.y)
    end
    if self.inputting and self.cursor_visible then
        local r, g, b = unpack(G_default_color)
        love.graphics.setColor(r, g, b, 96)
        local input_text = ''
        for _, character in ipairs(self.input_text) do input_text = input_text .. character end
        local x = 8 + self.font:getWidth('[root]arch~ ' .. input_text)
        love.graphics.rectangle('fill', x, self.lines[#self.lines].y,
            self.font:getWidth('w'), self.font:getHeight())
        love.graphics.setColor(r, g, b, 255)
    end
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
