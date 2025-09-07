Rock = Enemy:extend()

function Rock:new(area, x, y, opts)
	Rock.super.new(self, area, x, y, opts)
	self.name = "Rock"
	local direction = table.random({ -1, 1 })
	self.x = gw / 2 + direction * (gw / 2 + 48)
	self.y = GlobalRandom(16, gh - 16)
	self.collider = self.area.world:newPolygonCollider(CreateIrregularPolygon(8))
	self.collider:setPosition(self.x, self.y)
	self.collider:setObject(self)
	self.collider:setCollisionClass("Enemy")
	self.collider:setFixedRotation(false)


	self.velocity = -direction * GlobalRandom(20, 40)
	self.collider:setLinearVelocity(self.velocity, 0)
	self.collider:applyAngularImpulse(GlobalRandom(-100, 100))

	-- Calculate width and height from collider points
	-- get the points of the polygon shape, insert in a table, like a like
	-- then iterate to find the max x and y values, then double them to get width and height
	-- two by two
	local points = { self.collider.shapes.main:getPoints() }

	local maxX = -math.huge
	local maxY = -math.huge

	-- Iterate through the points table
	for i = 1, #points, 2 do
		local currentX = points[i]
		local currentY = points[i + 1]

		if currentX > maxX then
			maxX = currentX
		end

		if currentY > maxY then
			maxY = currentY
		end
	end
	-- Now, 'maxX' and 'maxY' hold the maximum x and y values
	self.w, self.h = maxX * 2, maxY * 2
end

function Rock:update(dt)
	Rock.super.update(self, dt)
end

function Rock:draw()
	love.graphics.setColor(G_hp_color)
	local points = { self.collider:getWorldPoints(self.collider.shapes.main:getPoints()) }
	love.graphics.polygon("line", points)
	love.graphics.setColor(G_default_color)
end

function Enemy:die()
	self.dead = true
	self.area:addGameObject("InfoText", self.x, self.y, { text = self.name, color = G_hp_color })
	self.area:addGameObject("EnemyDeathEffect", self.x, self.y, { color = G_hp_color, w = self.w, h = self.h })
	self.area:addGameObject("Ammo", self.x, self.y)
end

