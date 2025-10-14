Line = Object:extend()

function Line:new(node_1_id, node_2_id)
    self.node_1_id, self.node_2_id = node_1_id, node_2_id
    self.node_1, self.node_2 = TreeLogic.TreeStats[node_1_id], TreeLogic.TreeStats[node_2_id]
    self.color = {}
    for index, value in ipairs(GDefaultColor) do
        self.color[index] = value
    end
    self.active = false
end

function Line:update(dt)
    if not self.active then
        local node_1_bought = false
        local node_2_bought = false

        for _, value in ipairs(TreeLogic.BoughtNodeIndexes) do
            if (value == self.node_1) then
                node_1_bought = true
            end
            if (value == self.node_2_id) then
                node_2_bought = true
            end
        end
        self.active = node_1_bought and node_2_bought
    end
end

function Line:draw()
    love.graphics.setColor(GBackgroundColor)
    love.graphics.line(self.node_1.x, self.node_1.y, self.node_2.x, self.node_2.y)
    if self.active then
        love.graphics.setColor(self.color[1], self.color[2], self.color[3], 1)
    else
        love.graphics.setColor(self.color[1], self.color[2], self.color[3], 0.5)
    end
    love.graphics.line(self.node_1.x, self.node_1.y, self.node_2.x, self.node_2.y)
end
