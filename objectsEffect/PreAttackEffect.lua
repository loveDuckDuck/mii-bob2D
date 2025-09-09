PreAttackEffect = GameObject:extend()

function PreAttackEffect:new(area, x, y, opts)
    PreAttackEffect.super.new(self, area, x, y, opts)
    self.timer:every(0.02, function()
        self.area:addGameObject('TargetParticle', 
        self.x + GlobalRandom(-20, 20), self.y + GlobalRandom(-20, 20), 
        {target_x = self.x, target_y = self.y, color = self.color})
    end)
end

