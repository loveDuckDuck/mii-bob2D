ExplodeParticle = GameObject:extend()
--[[ 
    TODO: INVESTIGET WHY IT DOESNT WORK
]]
function ExplodeParticle:new(area, x, y, opts)
    ExplodeParticle.super.new(self, area, x, y, opts)

    self.color = opts.color or G_default_color
    self.rotation = GlobalRandom(0, 2 * math.pi)
    self.s = opts.s or GlobalRandom(2, 3)
    self.velocity = opts.v or GlobalRandom(75, 100)
    self.line_width = 1
    self.timer:tween(opts.d or GlobalRandom(0.3, 0.5), self, { s = 0, velocity = 0, line_width = 0 },
        'linear', function() self.dead = true end)
end
function ExplodeParticle:draw()
    PushRotate(self.x, self.y, self.rotation)
    love.graphics.setLineWidth(self.line_width)
    love.graphics.setColor(self.color)
    love.graphics.line(self.x - self.s, self.y, self.x + self.s, self.y)
    love.graphics.setColor(255, 255, 255)
    love.graphics.setLineWidth(1)
    love.graphics.pop()
end