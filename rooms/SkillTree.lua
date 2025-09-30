SkillTree = Object:extend()

function SkillTree:new()
    print("SkillTree created")
    self.timer = Timer()

    self.nodes = {}
    self.lines = {}
    for id, node in ipairs(TreeLogic.TreeStats) do table.insert(self.nodes, Node(id, node.x, node.y)) end
    for id, node in ipairs(TreeLogic.TreeStats) do
        for _, linked_node_id in ipairs(node.links) do
            table.insert(self.lines, Line(id, linked_node_id))
        end
    end
    self.previous_mx, self.previous_my = 0, 0
    self.main_canvas = love.graphics.newCanvas(gw, gh)
end

function SkillTree:update(dt)
    self.timer:update(dt)
    GCamera.smoother = Camera.smooth.damped(5)
    if GInput:pressed('zoomIn') then
        self.timer:tween('zoom', 0.2, GCamera, { scale = GCamera.scale + 0.4 }, 'in-out-cubic', function()
        end)
    end
    if GInput:pressed('zoomOut') then
        self.timer:tween('zoom', 0.2, GCamera, { scale = GCamera.scale - 0.4 }, 'in-out-cubic')
    end
    --[[
    TODO : update input file
    ]]
    if love.mouse.isDown(1) then
        local mx, my = GCamera:getMousePosition(sx, sy, 0, 0, sx * gw, sy * gh)
        local dx, dy = mx - self.previous_mx, my - self.previous_my

        GCamera:move(-dx, -dy)
    end
    self.previous_mx, self.previous_my = GCamera:getMousePosition(sx, sy, 0, 0, sx * gw, sy * gh)

    for _, node in ipairs(self.nodes) do node:update(dt) end
    for _, line in ipairs(self.lines) do line:update(dt) end
end

function SkillTree:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
    love.graphics.setColor(G_background_color)
    love.graphics.rectangle('fill', 0, 0, gw, gh)
    GCamera:attach(0, 0, gw, gh)
    love.graphics.setLineWidth(1 / GCamera.scale)
    for _, line in ipairs(self.lines) do line:draw() end
    for _, node in ipairs(self.nodes) do node:draw() end
    love.graphics.setLineWidth(1)
    GCamera:detach()


    -- Stats rectangle and create

    local testmx, testmy = love.mouse.getPosition()
    love.graphics.setColor(0.5, 0.5, 0.5, 222)
    love.graphics.circle('fill', testmx, testmy, 16)
    love.graphics.setFont(Font)
    for _, node in ipairs(self.nodes) do
        if node.hot then
            local stats = TreeLogic.TreeStats[node.id].stats
            -- Figure out max_text_width to be able to set the proper rectangle width
            local max_text_width = 0
            -- here cycle in pas by 3, to check the text of the multiplier
            for i = 1, #stats, 3 do
                if Font:getWidth(stats[i]) > max_text_width then
                    max_text_width = Font:getWidth(stats[i])
                end
            end
            -- Draw rectangle witch contains the text
            local mx, my = love.mouse.getPosition()
            mx, my = mx / sx, my / sy
            love.graphics.setColor(0, 0, 0, 222)
            love.graphics.rectangle('fill', mx, my, 16 + max_text_width,
                Font:getHeight() + (#stats / 3) * Font:getHeight())
            -- Draw the text
            -- here cycle in pas by 3, to check the text of the multiplier
            -- like we did previusly to check the lenght

            love.graphics.setColor(G_default_color)
            for i = 1, #stats, 3 do
                love.graphics.print(stats[i], math.floor(mx + 8),
                    math.floor(my + Font:getHeight() / 2 + math.floor(i / 3) * Font:getHeight()))
            end
        end
    end

    love.graphics.setCanvas()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode("alpha", "premultiplied")
    local x = (love.graphics.getWidth() - gw * sx) / 2
    local y = (love.graphics.getHeight() - gh * sy) / 2
    love.graphics.draw(self.main_canvas, x, y, 0, sx, sy)

    love.graphics.setBlendMode("alpha")
end

function SkillTree:destroy()
    self.area:destroy()
    self.area = nil
end
