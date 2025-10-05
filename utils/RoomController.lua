RoomController = Object:extend()

function RoomController:new()
	self.current_room = nil
	self.rooms = {}
	if type(self.rooms) ~= "table" then
		print("Error: self.rooms is not a table. It might be nil.")
	else
		print("i am table")
	end
	self.roomsName = {}
end

function RoomController:update(dt)
	if self.current_room then
		self.current_room:update(dt)
	end
end

function RoomController:draw()
	if self.current_room then
		self.current_room:draw()
	end
	if FlashFrames then
		FlashFrames = FlashFrames - 1
		if FlashFrames == -1 then
			FlashFrames = nil
		end
	end
	if FlashFrames then
		love.graphics.setColor(G_background_color)
		love.graphics.rectangle("fill", 0, 0, sx * GW, sy * GH)
		love.graphics.setColor(255, 255, 255)
	end
end

--[[
    -- Cause im persistent i need to chage this
    function gotoRoom(room_type, ...)
        if current_room and current_room.destroy then current_room:destroy() end
        current_room = _G[room_type](...)
    end

]]

function RoomController:gotoRoom(room_type, room_name, ...)
	print("room_type : ", room_type, " room_name : ", room_name)

	if self.current_room and self.rooms[room_name] then
		if self.current_room.deactivate then
			self.current_room:deactivate()
		end
		self.current_room = self.rooms[room_name]
		if self.current_room.activate then
			self.current_room:activate()
		end
	else
		self.current_room = self:addRoom(room_type, room_name, ...)
	end
end

function RoomController:addRoom(room_type, room_name, ...)
	local room = _G[room_type](room_name, ...)
	self.rooms[room_name] = room
	return room
end

function RoomController:getCurrentRoom()
	return self.current_room
end

return RoomController
