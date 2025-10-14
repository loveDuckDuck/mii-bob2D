TestingRoom = Object:extend()

function TestingRoom:new()       -- Create new TestingRoom object 📝
    print("TestingRoom created") -- Log TestingRoom creation ✅
    self.area = Area(self)       -- Create an area instance 🗺️

    self.area:addPhysicsWorld()
    self.area.world:addCollisionClass("Player")

    self.area.world:addCollisionClass("Projectile", { ignores = { "Player" } }) -- the world need to check

    self.area.world:addCollisionClass("Collectable", { ignores = { "Player", "Projectile" } })
    self.area.world:addCollisionClass("Enemy") --{ ignores = { "Enemy", "Collectable" } }

    self.area.world:addCollisionClass("EnemyProjectile", { ignores = { "EnemyProjectile", "Projectile", "Enemy" } })
    self.area.world:addCollisionClass("Wall")

    self.main_canvas = love.graphics.newCanvas(GW, GH) -- Create main canvas object 🖼️
    -- when instante this TestingRoom
    self.player = self.area:addGameObject("Player", GW / 2, GH / 2)

    -- self.wall =
    -- {
    --     self.area:addGameObject("Wall", 0, 0, { width = 1, height = GH }), --left
    --     self.area:addGameObject("Wall", GW, 0, { width = 1, height = GH }), -- rigth
    --     self.area:addGameObject("Wall", 0, 0, { width = GW, height = 1 }), -- up
    --     self.area:addGameObject("Wall", 0, GH, { width = GW, height = 1 }), -- down

    -- }


    self.score = 0
    self.font = Font
    self.counterAttack = 0
    -- GInput:bind("mouse1", function()
    --     self.counterAttack = self.counterAttack + 1

    --     if self.counterAttack > Lenght(Attacks) then
    --         self.counterAttack = 1
    --     end

    --     self.player:setAttack(table.keys(Attacks)[self.counterAttack])
    -- end)
    -- GInput:bind("mouse2", function()
    --     self.counterAttack = self.counterAttack - 1

    --     if self.counterAttack < 1 then
    --         self.counterAttack = Lenght(Attacks)
    --     end

    --     self.player:setAttack(table.keys(Attacks)[self.counterAttack])
    -- end)


    GInput:bind("z", function()
        self.counterAttack = self.counterAttack + 1
        if self.counterAttack > Lenght(Attacks) then
            self.counterAttack = 1
        end
        self.player:setAttack(table.keys(Attacks)[self.counterAttack])
    end)

    GCamera.smoother = Camera.smooth.damped(100)
end

function TestingRoom:update(dt) -- Update TestingRoom logic here 🕹️
    GCamera:lockPosition(dt, GW / 2, GH / 2)
    --GCamera:lookAt(self.player.x, self.player.y)
    GCamera:update(dt)
    self.area:update(dt) -- Update the area too 👍
end

function TestingRoom:draw()                   -- Drawing TestingRoom visuals here 🎨
    love.graphics.setCanvas(self.main_canvas) -- Set main canvas target 🎯
    love.graphics.clear()                     -- Clear the current frame 🧹

    --GCamera:attach()
    GCamera:attach(0, 0, GW, GH)
    self.area:draw() -- Draw the area now 👀

    GCamera:detach()
    -- Score
    love.graphics.setColor(GDefaultColor)
    love.graphics.print(
        self.score,
        GW - 20,
        10,
        0,
        1,
        1,
        math.floor(self.font:getWidth(self.score) / 2),
        self.font:getHeight() / 2
    )
    love.graphics.setColor(255, 255, 255)
    -- HP
    local r, g, b = unpack(GHPColor)
    local hp, max_hp = self.player.hp, self.player.max_hp
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle("fill", GW / 2 - 52, GH - 16, 48 * (hp / max_hp), 4)
    love.graphics.setColor(r - 32 / 255, g - 32 / 255, b - 32 / 255)
    love.graphics.rectangle("line", GW / 2 - 52, GH - 16, 48, 4)

    -- BOOST
    local r, g, b = unpack(GBoostColor)
    local boost, max_boost = self.player.boost, self.player.maxBoost
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle("fill", GW / 2, GH - 16, 48 * (boost / max_boost), 4)
    love.graphics.setColor(r - 32 / 255, g - 32 / 255, b - 32 / 255)
    love.graphics.rectangle("line", GW / 2, GH - 16, 48, 4)

    love.graphics.setCanvas()                            -- Reset the canvas 🔄

    love.graphics.setColor(1, 1, 1, 1)                   -- New 0-1 range for LÖVE 11.5
    love.graphics.setBlendMode("alpha", "premultiplied") -- Set blend mode here ⚙️
    --[[
        XXX: PROBLEM WITH RESOLUZIO AND SCALE NEED TO UNDERSTAND
    ]]
    local x = (love.graphics.getWidth() - GW * SX) / 2
    local y = (love.graphics.getHeight() - GH * SY) / 2
    love.graphics.draw(self.main_canvas, x, y, 0, SX, SY)

    love.graphics.setBlendMode("alpha") -- Reset the blend mode 🔄
    -- score
end

function TestingRoom:destroy()
    self.area:destroy()
    self.area = nil
end
