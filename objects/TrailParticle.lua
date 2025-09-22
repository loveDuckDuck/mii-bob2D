TrailParticle = GameObject:extend()

function TrailParticle:new(area, x, y, opts)
	TrailParticle.super.new(self, area, x, y, opts)
	self.radius = opts.radius or GlobalRandom(4, 6)
	self.timer:tween(opts.duration or GlobalRandom(0.3, 0.5), self, { radius = 0 }, "linear", function()
		self.dead = true
	end)
end

function TrailParticle:update(dt)
	TrailParticle.super.update(self, dt)
end

function TrailParticle:draw()
	love.graphics.setColor(self.parent.boosting and self.color or G_default_color)
	love.graphics.circle("fill", self.x, self.y, self.radius)
	love.graphics.setColor(255, 255, 255)
end
function TrailParticle:destroy()
	TrailParticle.super.destroy(self)
end
