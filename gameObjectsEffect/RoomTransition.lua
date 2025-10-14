RoomTransition = GameObject:extend()

function RoomTransition:new(area, x, y, opts)
    RoomTransition.super.new(self, area, x, y, opts)
    --[[
    TODO: avoid hard coding size of the reactangle evaulate the size of the player
    ]]
    self.layer = 100
    self.w, self.h = GW, GH
    self.y_offset = 0
    self.timer:tween(0.13, self, { h = 0, y_offset = 32 }, 'in-out-cubic',
        function() self.dead = true end)
end

function RoomTransition:update(dt)
    RoomTransition.super.update(self,dt)
    if self.parent then
        self.x, self.y = self.parent.x, self.parent.y - self.y_offset
    end
end

function RoomTransition:draw()
    love.graphics.setColor(GDefaultColor)
    love.graphics.rectangle('fill', self.x - self.w / 2, self.y, self.w, self.h)
    love.graphics.setColor(255, 255, 255)
end

function RoomTransition:destroy()
    RoomTransition.super.destroy(self)
end
