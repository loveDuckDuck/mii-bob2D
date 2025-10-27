Stage = Object:extend()

function Stage:new()
    self.area = Area(self)
    self.area:addPhysicsWorld()
    self.area.world:addCollisionClass('Enemy')
    self.area.world:addCollisionClass('Player')
    self.area.world:addCollisionClass('Projectile', {ignores = {'Projectile', 'Player'}})
    self.area.world:addCollisionClass('Collectable', {ignores = {'Collectable', 'Projectile'}})
    self.area.world:addCollisionClass('EnemyProjectile', {ignores = {'EnemyProjectile', 'Projectile', 'Enemy'}})

    self.font = fonts.m5x7_16
    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self.rgb_shift_canvas = love.graphics.newCanvas(gw, gh)
    self.final_canvas = love.graphics.newCanvas(gw, gh)
    self.player = self.area:addGameObject('Player', gw/2, gh/2)
    self.director = Director(self)

    self.rgb_shift = love.graphics.newShader('resources/shaders/rgb_shift.frag')
    self.rgb_shift_mag = 2

    self.score = 0
end

function Stage:update(dt)
    self.director:update(dt)

    camera.smoother = Camera.smooth.damped(5)
    camera:lockPosition(dt, gw/2, gh/2)

    self.area:update(dt)
end

function Stage:draw()
    love.graphics.setCanvas(self.rgb_shift_canvas)
    love.graphics.clear()
    	camera:attach(0, 0, gw, gh)
    	self.area:drawOnly({'rgb_shift'})
    	camera:detach()
    love.graphics.setCanvas()

    -- love.graphics.setCanvas(self.main_canvas)
    -- love.graphics.clear()
    --     camera:attach(0, 0, gw, gh)
    --     self.area:drawExcept({'rgb_shift'})
    --     camera:detach()
    -- love.graphics.setCanvas()

    love.graphics.setCanvas(self.final_canvas)
    love.graphics.clear()
        love.graphics.setColor(255, 255, 255)
        love.graphics.setBlendMode("alpha", "premultiplied")
  
        self.rgb_shift:send('amount', {
      	random(-self.rgb_shift_mag, self.rgb_shift_mag)/gw, 
      	random(-self.rgb_shift_mag, self.rgb_shift_mag)/gh})
        love.graphics.setShader(self.rgb_shift)
        love.graphics.draw(self.rgb_shift_canvas, 0, 0, 0, 1, 1)
        love.graphics.setShader()
  
  		love.graphics.draw(self.main_canvas, 0, 0, 0, 1, 1)
  		love.graphics.setBlendMode("alpha")
  	love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.final_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end

function Stage:destroy()
    self.area:destroy()
    self.area = nil
    self.player = nil
end

function Stage:finish()
    timer:after(1, function()
        gotoRoom('Stage')

        if not achievements['10K Fighter'] then
            achievements['10k Fighter'] = true
            -- Do whatever else that should be done when an achievement is unlocked
        end
    end)
end