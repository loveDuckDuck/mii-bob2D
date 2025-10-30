StartGameInfo = GameObject:extend()

function StartGameInfo:new(area, x, y, opts)
    StartGameInfo.super.new(self, area, x, y, opts)
    local textTitle =    "Welcome to the bob !"
    local textMovement = "W A S D   to    move    bob "
    local textArrow =    "ARROW     to    shoot   bob "
    local offset = 30

    self.graphics_types = { 'rgb_shift' }

    self.timer:every(0.7, function()
        self.area:addGameObject("InfoCircularText", GW / 2, GH / 2,
            {
                text = textTitle,
                color = GDefaultColor,
                scaleFactor = SX,

            })

        self.area:addGameObject("InfoCircularText", GFont:getWidth(textTitle)  , GH / 2,
            {
                text = textMovement,
                color = GDefaultColor,
                scaleFactor = SX,

            })

        self.area:addGameObject("InfoCircularText", GW - GFont:getWidth(textTitle, GH / 2), GH / 2,
            {
                text = textArrow,
                color = GDefaultColor,
                scaleFactor = SX,

            })

    end, 11)

    self.timer:after(4.7, function()
        self.dead = true
    end)
end

function StartGameInfo:destroy()
    StartGameInfo.super.destroy(self)
end
