Enemy = GameObject:extend()

function Enemy:new(area, x, y, opts)
	Enemy.super.new(self, area, x, y, opts)
	self.name = opts.name or "Enemy"
	self.hp = opts.hp or 10
	self.w, self.h = 8, 8
end

function Enemy:update(dt)
	Enemy.super.update(self, dt)
	self:hit(dt)
end

function Enemy:draw() end

function Enemy:hit(dt)
	if self.collider:enter("Projectile") then
		local collision_data = self.collider:getEnterCollisionData("Projectile")
		local object = collision_data.collider:getObject()
		if object:is(Projectile) then
			self.hp = self.hp - object.damage
			if self.hp <= 0 then
				self:die()
			end
			object:explode()
		end
	end
end
