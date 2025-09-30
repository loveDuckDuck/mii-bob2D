--[[
LightningLine

A GameObject subclass that generates and animates a lightning bolt effect between two points.
The lightning is procedurally generated using recursive subdivision, creating a jagged line
with configurable generations and offset. The effect fades out over a short duration.

Constructor:
    LightningLine:new(area, x, y, opts)
        area (table): The game area or context.
        x, y (number): Initial position (not directly used, as x1/y1 and x2/y2 are expected in opts).
        opts (table): Options table, expects:
            x1, y1 (number): Start point of the lightning.
            x2, y2 (number): End point of the lightning.
            generations (number, optional): Number of recursive subdivisions (default: 4).
            max_offset (number, optional): Maximum offset for jaggedness (default: 8).
            duration (number, optional): How long the lightning lasts in seconds (default: 0.15).

Methods:
    update(dt)
        Updates the lightning's state. Handles fading and lifetime.

    generate()
        Procedurally generates the lightning's jagged line segments using recursive subdivision.

    draw()
        Draws the lightning lines with a colored outline and a core color, using current alpha.

    destroy()
        Cleans up the object.

Fields:
    lines (table): List of line segments representing the lightning.
    alpha (number): Current opacity (fades out over time).
    dead (boolean): Set to true when the effect is finished.
]]
LightningLine = GameObject:extend()

function LightningLine:new(area, x, y, opts)
    LightningLine.super.new(self, area, x, y, opts)

    self.lines = {}
    self.x, self.y = (self.x1 + self.x2) / 2, (self.y1 + self.y2) / 2
    table.insert(self.lines, { x1 = self.x1, y1 = self.y1, x2 = self.x2, y2 = self.y2 })
    self.generations = opts.generations or 4
    self.max_offset = opts.max_offset or 8
    self:generate()
    self.duration = opts.duration or 0.15
    self.alpha = 255
    self.timer:tween(self.duration, self, { alpha = 0 }, 'in-out-cubic', function() self.dead = true end)

end

function LightningLine:update(dt)
    LightningLine.super.update(self, dt)
end

function LightningLine:generate()
    local offset_amount = self.max_offset
    local lines = self.lines

    for j = 1, self.generations do
        for i = #lines, 1, -1 do
            local start_point = Vector(lines[i].x1, lines[i].y1)
            local end_point = Vector(lines[i].x2, lines[i].y2)
            table.remove(lines, i)

            local mid_point = (start_point + end_point) / 2
            mid_point = mid_point +
            (end_point - start_point):normalized():perpendicular() * math.customRandom(-offset_amount, offset_amount)
            table.insert(lines, { x1 = start_point.x, y1 = start_point.y, x2 = mid_point.x, y2 = mid_point.y })
            table.insert(lines, { x1 = mid_point.x, y1 = mid_point.y, x2 = end_point.x, y2 = end_point.y })
        end
        offset_amount = offset_amount / 2
    end
end

function LightningLine:draw()
    for i, line in ipairs(self.lines) do
        local r, g, b = unpack(G_boost_color)
        love.graphics.setColor(r, g, b, self.alpha)
        love.graphics.setLineWidth(2.5)
        love.graphics.line(line.x1, line.y1, line.x2, line.y2)

        local r, g, b = unpack(G_default_color)
        love.graphics.setColor(r, g, b, self.alpha)
        love.graphics.setLineWidth(1.5)
        love.graphics.line(line.x1, line.y1, line.x2, line.y2)
    end
    love.graphics.setLineWidth(1)
    love.graphics.setColor(255, 255, 255, 255)
end

function LightningLine:destroy()
    LightningLine.super.destroy(self)
end
