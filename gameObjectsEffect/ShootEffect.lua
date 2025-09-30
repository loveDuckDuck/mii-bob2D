ShootEffect = GameObject:extend()
function ShootEffect:new(area, x, y, opts)
    ShootEffect.super.new(self, area, x, y, opts)
    self.x, self.y = x, y
    self.color = Attacks[self.attack].color or G_default_color
    self.w = 8
    self.timer:tween(0.1, self, { w = 0 }, 'in-out-cubic', function() self.dead = true end)
end

function ShootEffect:update(dt)
    ShootEffect.super.update(self, dt)
    if self.player then
        self.x = self.player.x + self.distance * math.cos(self.player.rotation)
        self.y = self.player.y + self.distance * math.sin(self.player.rotation)
    end
end

function ShootEffect:draw()
    PushRotate(self.x, self.y, self.player.rotation + math.pi / 4)
	love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x - self.w / 2, self.y - self.w / 2, self.w, self.w)
    love.graphics.pop()

end

function ShootEffect:destroy()
    ShootEffect.super.destroy(self)
end

--return ShootEffect
