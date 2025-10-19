StartGameInfo = GameObject:extend()

function StartGameInfo:new(area, x, y, opts)
    StartGameInfo.super.new(self, area, x, y, opts)
    self.text = opts.text or "Welcome to the Game!"



    self.timer:every(1.15, function()
        self.area:addGameObject("InfoCircularText", GW / 2, GH / 2 ,
            {
                text = self.text,
                color = GDefaultColor,
                scaleFactor = 3,

            })
    end, 3)
end


function StartGameInfo:destroy()
    StartGameInfo.super.destroy(self)
end
