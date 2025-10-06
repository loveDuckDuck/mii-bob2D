HasteArea = GameObject:extend()

function HasteArea:new(area, x, y, opts)
	HasteArea.super.new(self, area, x, y, opts)
	if opts.parent then
		self.parent = opts.parent
	else
		self.parent = GRoom.current_room.player
	end
	self.radius = math.customRandom(64, 96)
	self.timer:after(4, function()
		self.timer:tween(0.25, self, { radius = 0 }, "in-out-cubic", function()
			self.dead = true
		end)
	end)
end

function HasteArea:update(dt)
	HasteArea.super.update(self, dt)
	local distance = GlobalDistance(self.x, self.y, self.parent.x, self.parent.y)
	if distance < self.radius and not self.parent.insideHasteArea then -- Enter event
		self.parent.insideHasteArea = true
	elseif distance >= self.radius and self.parent.insideHasteArea then -- Leave event
		self.parent.insideHasteArea = false
	end
end

function HasteArea:draw()
	love.graphics.setColor(G_ammo_color)
	love.graphics.circle("line", self.x, self.y, self.radius + math.customRandom(-2, 2))
	love.graphics.setColor(G_default_color)
end
