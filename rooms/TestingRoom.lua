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

    self.main_canvas = love.graphics.newCanvas(gw, gh) -- Create main canvas object 🖼️
    -- when instante this TestingRoom
    self.player = self.area:addGameObject("Player", gw / 2, gh / 2)

    -- self.wall =
    -- {
    --     self.area:addGameObject("Wall", 0, 0, { width = 1, height = gh }), --left
    --     self.area:addGameObject("Wall", gw, 0, { width = 1, height = gh }), -- rigth
    --     self.area:addGameObject("Wall", 0, 0, { width = gw, height = 1 }), -- up
    --     self.area:addGameObject("Wall", 0, gh, { width = gw, height = 1 }), -- down

    -- }


    self.score = 0
    self.font = Font
    self.counterAttack = 0
    -- InputHandler:bind("mouse1", function()
    --     self.counterAttack = self.counterAttack + 1

    --     if self.counterAttack > Lenght(Attacks) then
    --         self.counterAttack = 1
    --     end

    --     self.player:setAttack(table.keys(Attacks)[self.counterAttack])
    -- end)
    -- InputHandler:bind("mouse2", function()
    --     self.counterAttack = self.counterAttack - 1

    --     if self.counterAttack < 1 then
    --         self.counterAttack = Lenght(Attacks)
    --     end

    --     self.player:setAttack(table.keys(Attacks)[self.counterAttack])
    -- end)


    InputHandler:bind("z", function()
        self.counterAttack = self.counterAttack + 1
        if self.counterAttack > Lenght(Attacks) then
            self.counterAttack = 1
        end
        self.player:setAttack(table.keys(Attacks)[self.counterAttack])
    end)

    GlobalCamera.smoother = Camera.smooth.damped(100)
end

function TestingRoom:update(dt) -- Update TestingRoom logic here 🕹️
    GlobalCamera:lockPosition(dt, gw / 2, gh / 2)
    --GlobalCamera:lookAt(self.player.x, self.player.y)
    GlobalCamera:update(dt)
    self.area:update(dt) -- Update the area too 👍
end

function TestingRoom:draw()                   -- Drawing TestingRoom visuals here 🎨
    love.graphics.setCanvas(self.main_canvas) -- Set main canvas target 🎯
    love.graphics.clear()                     -- Clear the current frame 🧹

    --GlobalCamera:attach()
    GlobalCamera:attach(0, 0, gw, gh)
    self.area:draw() -- Draw the area now 👀

    GlobalCamera:detach()
    -- Score
    love.graphics.setColor(G_default_color)
    love.graphics.print(
        self.score,
        gw - 20,
        10,
        0,
        1,
        1,
        math.floor(self.font:getWidth(self.score) / 2),
        self.font:getHeight() / 2
    )
    love.graphics.setColor(255, 255, 255)
    -- HP
    local r, g, b = unpack(G_hp_color)
    local hp, max_hp = self.player.hp, self.player.max_hp
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle("fill", gw / 2 - 52, gh - 16, 48 * (hp / max_hp), 4)
    love.graphics.setColor(r - 32 / 255, g - 32 / 255, b - 32 / 255)
    love.graphics.rectangle("line", gw / 2 - 52, gh - 16, 48, 4)

    -- BOOST
    local r, g, b = unpack(G_boost_color)
    local boost, max_boost = self.player.boost, self.player.maxBoost
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle("fill", gw / 2, gh - 16, 48 * (boost / max_boost), 4)
    love.graphics.setColor(r - 32 / 255, g - 32 / 255, b - 32 / 255)
    love.graphics.rectangle("line", gw / 2, gh - 16, 48, 4)

    love.graphics.setCanvas()                            -- Reset the canvas 🔄

    love.graphics.setColor(1, 1, 1, 1)                   -- New 0-1 range for LÖVE 11.5
    love.graphics.setBlendMode("alpha", "premultiplied") -- Set blend mode here ⚙️
    --[[
        XXX: PROBLEM WITH RESOLUZIO AND SCALE NEED TO UNDERSTAND
    ]]
    local x = (love.graphics.getWidth() - gw * sx) / 2
    local y = (love.graphics.getHeight() - gh * sy) / 2
    love.graphics.draw(self.main_canvas, x, y, 0, sx, sy)

    love.graphics.setBlendMode("alpha") -- Reset the blend mode 🔄
    -- score
end

function TestingRoom:destroy()
    self.area:destroy()
    self.area = nil
end
