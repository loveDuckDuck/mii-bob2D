EnemyDeathEffect = GameObject:extend()

function EnemyDeathEffect:new(area, x, y, opts)
    EnemyDeathEffect.super.new(self, area, x, y, opts)
    self.w = opts.w or 8
    self.h = opts.h or 8
    self.first = true
    self.timer:after(0.1, function()
        self.first = false
        self.second = true
        self.timer:after(0.25, function()
            self.second = false
            self.dead = true
        end)
    end)
end

function EnemyDeathEffect:update(dt)
    EnemyDeathEffect.super.update(self,dt)
end

function EnemyDeathEffect:draw()
    if self.first then
        love.graphics.setColor(G_default_color)
    elseif self.second then
        love.graphics.setColor(self.color)
    end
    love.graphics.rectangle('fill', self.x - self.w / 2, self.y - self.w / 2, self.w, self.h)
    
end

