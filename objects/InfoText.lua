InfoText = GameObject:extend()

function InfoText:new(area, x, y, opts)
	InfoText.super.new(self, area, x, y, opts)
	self.font = Font
	self.layer = 80
	self.background_colors = {}
	self.foreground_colors = {}
	self.characters = {}
        self.all_colors = Moses.append(G_default_colors, G_negative_colors)
	for i = 1, #self.text do
		table.insert(self.characters, self.text:utf8sub(i, i))
	end
	self.visible = true
	self.timer:after(0.70, function()
		self.timer:every(0.05, function()
			self.visible = not self.visible
		end, 6)
		self.timer:after(0.35, function()
			self.visible = true
		end)
	end)
	self.timer:after(1.10, function()
		self.dead = true
	end)

	self.timer:after(0.70, function()
		self.timer:every(0.035, function()
			for i, character in ipairs(self.characters) do
				if love.math.random(1, 20) <= 1 then
					-- change character
					local r = love.math.random(1, #G_random_characters)
					self.characters[i] = G_random_characters:utf8sub(r, r)
				else
					-- leave character as it is
					self.characters[i] = character
				end
                -- set random color to it
				if love.math.random(1, 10) <= 1 then
					self.background_colors[i] = table.random(self.all_colors)
				else
					self.background_colors[i] = nil
				end

				if love.math.random(1, 10) <= 2 then
					self.foreground_colors[i] = table.random(self.all_colors)
				else
					self.background_colors[i] = nil
				end
			end
		end)
	end)
end

function InfoText:draw()
	love.graphics.setFont(self.font)
	for i = 1, #self.characters do
		local width = 0

		if self.background_colors[i] then
			love.graphics.setColor(self.background_colors[i])
			love.graphics.rectangle(
				"fill",
				self.x + width,
				self.y - self.font:getHeight() / 2,
				self.font:getWidth(self.characters[i]),
				self.font:getHeight()
			)
		end
		love.graphics.setColor(self.foreground_colors[i] or self.color or G_default_color)
		love.graphics.print(self.characters[i], self.x + width, self.y, 0, 1, 1, 0, self.font:getHeight() / 2)
	end
end
