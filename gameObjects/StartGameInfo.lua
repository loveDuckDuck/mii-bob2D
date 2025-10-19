StartGameInfo = GameObject:extend()

function StartGameInfo:new(area, x, y, opts)
    StartGameInfo.super.new(self, area, x, y, opts)
    self.text = opts.text or "Welcome to the bob !"
    local textMovement = "W A S D   to    move    bob "
    local textShoot =    "arrow     to    shoot   bob "

    self.timer:every(0.7, function()
        self.area:addGameObject("InfoCircularText", GW / 2, GH / 2,
            {
                text = self.text,
                color = GDefaultColor,
                scaleFactor = SX,

            })

        self.area:addGameObject("InfoCircularText", GW - GFont:getWidth(textMovement)  , GH / 2,
            {
                text = textMovement,
                color = GDefaultColor,
                scaleFactor = SX,

            })
        self.area:addGameObject("InfoCircularText", GFont:getWidth(textMovement) , GH / 2,
            {
                text = textShoot,
                color = GDefaultColor,
                scaleFactor = SX ,

            })
    end, 11)

    self.timer:after(4.7, function()
        self.dead = true
    end)
end

function StartGameInfo:destroy()
    StartGameInfo.super.destroy(self)
end
