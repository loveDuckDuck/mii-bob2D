--[[
InfoCircularText Class

A subclass of GameObject that displays animated text with per-character color and character changes.
The text appears at a given position, with each character potentially having its own foreground and background color,
and may randomly change to another character for a "glitch" effect. The text blinks and disappears after a short duration.

Constructor:
	InfoCircularText:new(area, x, y, opts)
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
	InfoCircularText:draw()
		Draws the text, applying per-character colors and background rectangles.

	InfoCircularText:destroy()
		Cleans up the object.

Behavior:
	- The text blinks after 0.7 seconds, toggling visibility several times.
	- After 1.1 seconds, the text is marked as dead.
	- Characters and their colors are randomly changed for a "glitch" effect.
	- Each character may have a random background and/or foreground color.
]]
InfoCircularText = GameObject:extend()

function InfoCircularText:new(area, x, y, opts)
    InfoCircularText.super.new(self, area, x, y, opts)
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

function InfoCircularText:calcHalfCharRotation(char, font, radius)
    local length = font:getWidth(char) / 2
    local rotation = ((length * 1.2) / radius) -- il * 1.2 lo riempie e lo fa sembrare più bello.
    return rotation
end

function InfoCircularText:draw()
    if not self.visible then return end


    -- 1. Pre-calculate the total unscaled width
    local total_unscaled_width = 0
    for i = 1, #self.characters do
        total_unscaled_width = total_unscaled_width + self.font:getWidth(self.characters[i])  / (2 * math.pi)
    end

    local radius = total_unscaled_width -- calcola un raggio approssimativo in base alla lunghezza del testo
    local rotation = -self:calcHalfCharRotation(string.sub(self.text, 1, 1), GFont, radius)

    for i = 1, #self.characters do
        local char = self.characters[i]

        -- ottieni la lunghezza dei pixel che il carattere occuperà
        local length = GFont:getWidth(char)

        -- aggiungi metà dell'arco alla rotazione. Poiché stiamo disegnando al centro del carattere, per ora vogliamo solo metà della rotazione.
        -- Per il primo carattere, non vogliamo che sia ruotato affatto, quindi questo annulla la metà negativa da prima del ciclo.
        rotation = rotation + self:calcHalfCharRotation(char, GFont, radius)
        love.graphics.setColor(self.foreground_colors[i] or self.color or GDefaultColor)

        love.graphics.print(
            char,                        -- testo da stampare
            self.x,                      -- posizione x, in questo caso è il centro del cerchio
            self.y,                      -- posizione y
            rotation,                    -- rotazione
            self.scaleFactor,            -- scala X
            self.scaleFactor,            -- scala Y
            length / 2,                  -- offset x, questo mantiene la lettera centrata, poiché metà della lunghezza la mette nel mezzo
            radius                            -- offset y, questo dice di disegnare (raggio) pixel di distanza dal centro del cerchio
        -- L'offset dice di ruotare attorno al centro del cerchio
        )
    end

    love.graphics.setColor(GDefaultColor)
end

function InfoCircularText:destroy()
    InfoCircularText.super.destroy(self)
end
