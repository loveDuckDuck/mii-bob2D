SkillTree = Object:extend()

function SkillTree:new()       -- Create new SkillTree object 📝
    print("SkillTree created") -- Log SkillTree creation ✅
    self.timer = Timer()

    local tree = {}
    tree[1] = { x = 0, y = 0 }
    tree[2] = { x = 32, y = 0 }
    self.nodes = {}
    for _, node in ipairs(tree) do table.insert(self.nodes, Node(node.x, node.y)) end

    self.main_canvas = love.graphics.newCanvas(gw, gh) -- Create main canvas object 🖼️
end

function SkillTree:update(dt) -- Update SkillTree logic here 🕹️
    --GlobalCamera:lookAt(self.player.x, self.player.y)
    if InputHandler:pressed('zoomIn') then
        print("InputHandler:pressed('zoomIn') zoomIn")
        self.timer:tween('zoom', 0.2, GlobalCamera, { scale = GlobalCamera.scale + 1 }, 'in-out-cubic', function()
            print("HELLO")
        end)

        print(GlobalCamera.scale)
    end
    if InputHandler:pressed('zoomOut') then
        print("InputHandler:pressed('zoomOut') zoomOut")
        self.timer:tween('zoom', 0.2, GlobalCamera, { scale = GlobalCamera.scale - 1 }, 'in-out-cubic')

        print(GlobalCamera.scale)
    end
    InputHandler:bind("mouse1", function()
        local mx, my = GlobalCamera:getMousePosition(sx, sy, 0, 0, sx * gw, sy * gh)
        local dx, dy = mx - self.previous_mx, my - self.previous_my
        GlobalCamera:move(-dx, -dy)
        print("move")
    end)
    self.previous_mx, self.previous_my = GlobalCamera:getMousePosition(sx, sy, 0, 0, sx * gw, sy * gh)
    GlobalCamera:update(dt)
end

function SkillTree:draw()                     -- Drawing SkillTree visuals here 🎨
    love.graphics.setCanvas(self.main_canvas) -- Set main canvas target 🎯
    love.graphics.clear()                     -- Clear the current frame 🧹

    --GlobalCamera:attach()
    GlobalCamera:attach(0, 0, gw, gh)
    for _, value in ipairs(self.nodes) do
        value:draw()
    end

    GlobalCamera:detach()

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
end

function SkillTree:destroy()
    self.area:destroy()
    self.area = nil
end
