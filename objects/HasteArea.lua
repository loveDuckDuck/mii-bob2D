HasteArea = GameObject:extend()

function HasteArea:new(area, x, y, opts)
	HasteArea.super.new(self, area, x, y, opts)
	self.radius = GlobalRandom(64, 96)
	self.timer:after(4, function()
		self.timer:tween(0.25, self, { radius = 0 }, "in-out-cubic", function()
			self.dead = true
		end)
	end)
end

function HasteArea:update(dt)
	HasteArea.super.update(self, dt)
	local player = GlobalRoomController.current_room.player
	if not player then
		return
	end
	local distance = GlobalDistance(self.x, self.y, player.x, player.y)
	if distance < self.radius and not player.insideHasteArea then -- Enter event
		player:enterHasteArea()
	elseif distance >= self.radius and player.insideHasteArea then -- Leave event
		player:exitHasteArea()
	end
end

function HasteArea:draw()
	love.graphics.setColor(G_ammo_color)
	love.graphics.circle("line", self.x, self.y, self.radius + GlobalRandom(-2, 2))
	love.graphics.setColor(G_default_color)
end
