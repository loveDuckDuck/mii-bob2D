--[[
InfoText Class

A subclass of GameObject that displays animated text with per-character color and character changes.
The text appears at a given position, with each character potentially having its own foreground and background color,
and may randomly change to another character for a "glitch" effect. The text blinks and disappears after a short duration.

Constructor:
	InfoText:new(area, x, y, opts)
		area (object): The game area or context.
		x (number): X position of the text.
		y (number): Y position of the text.
		opts (table): Additional options, including the 'text' to display.

Fields:
	font (Font): The font used for rendering the text.
	layer (number): The rendering layer.
	background_colors (table): Per-character background colors.
	foreground_colors (table): Per-character foreground colors.
	characters (table): The current characters being displayed.
	all_colors (table): List of all possible colors for random selection.
	visible (boolean): Whether the text is currently visible.
	dead (boolean): Whether the text should be removed.

Methods:
	InfoText:draw()
		Draws the text, applying per-character colors and background rectangles.

	InfoText:destroy()
		Cleans up the object.

Behavior:
	- The text blinks after 0.7 seconds, toggling visibility several times.
	- After 1.1 seconds, the text is marked as dead.
	- Characters and their colors are randomly changed for a "glitch" effect.
	- Each character may have a random background and/or foreground color.
]]
InfoText = GameObject:extend()

function InfoText:new(area, x, y, opts)
	InfoText.super.new(self, area, x, y, opts)
	self.font = Font
	self.layer = 80
	self.background_colors = {}
	self.foreground_colors = {}
	self.characters = {}
	local random_characters = "0123456789!@#$%¨&*()-=+[]^~/;?><.,|abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWYXZ"
	
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
					local r = love.math.random(1, #random_characters)
					self.characters[i] = random_characters:utf8sub(r, r)
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
    if not self.visible then return end

    --love.graphics.setFont(self.font)
    for i = 1, #self.characters do
        local width = 0
        if i > 1 then
            for j = 1, i-1 do
                width = width + self.font:getWidth(self.characters[j])
            end
        end

        if self.background_colors[i] then
      		love.graphics.setColor(self.background_colors[i])
      		love.graphics.rectangle('fill', self.x + width, self.y - self.font:getHeight()/2, self.font:getWidth(self.characters[i]), self.font:getHeight())
      	end
    	love.graphics.setColor(self.foreground_colors[i] or self.color or G_default_color)
    	love.graphics.print(self.characters[i], self.x + width, self.y, 0, 1, 1, 0, self.font:getHeight()/2)
    end
    love.graphics.setColor(G_default_color)
end

function InfoText:destroy()
    InfoText.super.destroy(self)
end