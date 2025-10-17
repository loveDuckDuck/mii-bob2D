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
	font (GFont): The font used for rendering the text.
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
	self.font = GFont
	self.layer = 80
	self.background_colors = {}
	self.foreground_colors = {}
	self.characters = {}
	self.scaleFactor = opts.scaleFactor or 1
	local random_characters = "0123456789!@#$%¨&*()-=+[]^~/;?><.,|abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWYXZ"
	
	self.all_colors = Moses.append(GDefaultColors, G_negative_colors)
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

    local scale_factor = 10 -- Define your scale factor once (NOTE: Changed self.scaleFactor to this local var for consistency with your snippet)
    love.graphics.setFont(self.font) -- Ensure font is set outside the loop

    -- 1. Pre-calculate the total unscaled width
    local total_unscaled_width = 0
    for i = 1, #self.characters do
        total_unscaled_width = total_unscaled_width + self.font:getWidth(self.characters[i])
    end
    local font_height_unscaled = self.font:getHeight()

    love.graphics.push() -- Push the state once for the entire text

    -- 1. Translate the origin to the intended center point (self.x, self.y)
    love.graphics.translate(self.x, self.y)

    -- 2. Scale the coordinate system
    love.graphics.scale(self.scaleFactor, self.scaleFactor)

    -- 3. CRITICAL CENTERING STEP: Translate backward by half the total unscaled size.
    -- This makes the whole scaled text centered on the original (self.x, self.y).
    love.graphics.translate(-total_unscaled_width / 2, -font_height_unscaled / 2)


    local accumulated_width_unscaled = 0 -- We'll track the width in the new *scaled* system

    for i = 1, #self.characters do
        local char = self.characters[i]
        local char_width_unscaled = self.font:getWidth(char)

        -- Background Rectangle
        if self.background_colors[i] then
            love.graphics.setColor(self.background_colors[i])
            -- The position is accumulated_width_unscaled, Y position is 0 relative to the adjusted origin.
            love.graphics.rectangle(
                'fill',
                accumulated_width_unscaled,                     -- X position (relative to the adjusted origin)
                0,                                              -- Y position (relative to the adjusted origin)
                char_width_unscaled,                            -- Width
                font_height_unscaled                            -- Height
            )
        end

        -- Foreground Text
        love.graphics.setColor(self.foreground_colors[i] or self.color or GDefaultColor)
        love.graphics.print(
            char,
            accumulated_width_unscaled,                         -- X position (relative to the adjusted origin)
            0,                                                  -- Y position (relative to the adjusted origin)
            0,                                                  -- Rotation (r)
            1, 1,                                               -- Scale factors (sx, sy)
            0, 0                                                -- Origin offset (ox, oy) - NO offset needed here
        )

        -- Update the accumulated width for the next character
        accumulated_width_unscaled = accumulated_width_unscaled + char_width_unscaled
    end

    love.graphics.pop() -- Restore the previous state
    love.graphics.setColor(GDefaultColor)
end
function InfoText:destroy()
	InfoText.super.destroy(self)
end