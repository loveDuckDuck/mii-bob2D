StartGameInfo = GameObject:extend()

function StartGameInfo:new(area, x, y, opts)
    StartGameInfo.super.new(self, area, x, y, opts)
    self.text = opts.text or "Welcome to the bob !"
    -- local textMovement = "W A S D   to    move    bob "
    -- local textArrow =    "arrow     to    shoot   bob "
    local textWASD = "W A S D"
    local textMove = "to move"
    local textArrow = "ARROW"
    local textToShoot = "to shoot"
    local offset = 30

    self.graphics_types = { 'rgb_shift' }

    self.timer:every(0.7, function()
        self.area:addGameObject("InfoCircularText", GW / 2, GH / 2,
            {
                text = self.text,
                color = GDefaultColor,
                scaleFactor = SX,

            })

        self.area:addGameObject("InfoText", GW - offset * 3, GH / 2 - offset,
            {
                text = textWASD,
                color = GDefaultColor,
                scaleFactor = SX,

            })

        self.area:addGameObject("InfoText", GW - offset* 3, GH / 2 + offset,
            {
                text = textMove,
                color = GDefaultColor,
                scaleFactor = SX,

            })

        self.area:addGameObject("InfoText",offset* 3, GH / 2 - offset,
            {
                text = textArrow,
                color = GDefaultColor,
                scaleFactor = SX,

            })

        self.area:addGameObject("InfoText",offset* 3, GH / 2 + offset,
            {
                text = textToShoot,
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
