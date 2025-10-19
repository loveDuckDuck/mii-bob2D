InfoCircularText = GameObject:extend()

function InfoCircularText:new(area, x, y, opts)
    InfoCircularText.super.new(self, area, x, y, opts)
    self.font = GFont
    self.layer = 80
    self.background_colors = {}
    self.foreground_colors = {}
    self.characters = {}
    self.scaleFactor = opts.scaleFactor or 2
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
    local length = self.font:getWidth(char) 
    local rotation = ((length * 2) / radius) -- il * 1.2 lo riempie e lo fa sembrare più bello.
    return rotation
end

function InfoCircularText:draw()
    if not self.visible then return end

    local radius = self.font:getWidth(self.text) / math.pi  -- calcola un raggio approssimativo in base alla lunghezza del testo
    local rotation = -self:calcHalfCharRotation(string.sub(self.text, 1, 1), self.font, radius)

    for i = 1, #self.characters do
        local char = self.characters[i]

        -- ottieni la lunghezza dei pixel che il carattere occuperà
        local length = GFont:getWidth(char)

        rotation = rotation + self:calcHalfCharRotation(char, GFont, radius)
        love.graphics.setColor(self.foreground_colors[i] or self.color or GDefaultColor)

        love.graphics.print(
            char,
            self.x,
            self.y,
            rotation,
            self.scaleFactor,
            self.scaleFactor,
            length /2 ,
            radius

        )
    end

    love.graphics.setColor(GDefaultColor)
end

function InfoCircularText:destroy()
    InfoCircularText.super.destroy(self)
end
