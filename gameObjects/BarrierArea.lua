BarrierArea = GameObject:extend()

function BarrierArea:new(area, x, y, opts)
	BarrierArea.super.new(self, area, x, y, opts)
	if opts.parent then
		self.parent = opts.parent
	else
		self.parent = GlobalRoomController.current_room.player
	end
	self.radius = math.customRandom(80, 122)
	self.color = table.random(G_negative_colors)

	-- PHYSICS
	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.radius)
	self.collider:setObject(self)
	self.collider:setCollisionClass("Barrier")
	self.collider:setType("static")

	self.timer:after(4, function()
		self.timer:tween(0.25, self, { radius = 0 }, "in-out-cubic", function()
			self.dead = true
		end)
	end)
end

function BarrierArea:update(dt)
	BarrierArea.super.update(self, dt)
end

function BarrierArea:draw()
	love.graphics.setColor(self.color)
	love.graphics.circle("line", self.x, self.y, self.radius + math.customRandom(-2, 2))
	love.graphics.setColor(G_default_color)
end
