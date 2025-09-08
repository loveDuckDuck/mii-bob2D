BoostCoinEffect = GameObject:extend()

function BoostCoinEffect:new(area, x, y, opts)
	BoostCoinEffect.super.new(self, area, x, y, opts)
	self.current_color = G_default_color
	self.timer:after(0.2, function()
		self.current_color = self.color
		self.timer:after(0.35, function()
			self.dead = true
		end)
	end)
	self.visible = true
	self.timer:after(0.2, function()
		self.timer:every(0.05, function()
			self.visible = not self.visible
		end, 6)
		self.timer:after(0.35, function()
			self.visible = true
		end)
	end)

	self.sx, self.sy = 1, 1
	self.timer:tween(0.35, self, { sx = 2, sy = 2 }, "in-out-cubic")
end

function BoostCoinEffect:update(dt)
	BoostCoinEffect.super.update(self, dt)
end

function BoostCoinEffect:draw()
	if not self.visible then
		return
	end

	love.graphics.setColor(self.current_color)
	DraftDrawer:rhombus(self.x, self.y, 1.34 * self.w, 1.34 * self.h, "fill")
    DraftDrawer:rhombus(self.x, self.y, self.sx*2*self.w, self.sy*2*self.h, 'line')
    love.graphics.setColor(G_default_color)
end

function BoostCoinEffect:destroy()
	BoostCoinEffect.super.destroy(self)
end