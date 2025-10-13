RoomController = Object:extend()

function RoomController:new()
	self.current_room = nil
	self.rooms = {}
	if type(self.rooms) ~= "table" then
		print("Error: self.rooms is not a table. It might be nil.")
	else
		print("i am table")
	end
	self.roomsCreated = {}
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
		love.graphics.rectangle("fill", 0, 0, SX * GW, SY * GH)
		love.graphics.setColor(255, 255, 255)
	end
end

function RoomController:gotoRoom(roomName, roomUUID, ...)
	print("roomName : ", roomName, " roomUUID : ", roomUUID)
	self.roomsCreated = {[roomName] = roomUUID}
	if self.current_room and self.rooms[roomUUID] then
		if self.current_room.deactivate then
			self.current_room:deactivate()
		end
		self.current_room = self.rooms[roomUUID]
		if self.current_room.activate then
			self.current_room:activate()
		end
	else
		self.current_room = self:addRoom(roomName, roomUUID, ...)
	end
end

function RoomController:addRoom(roomName, roomUUID, ...)
	local room = _G[roomName](roomUUID, ...)
	self.rooms[roomUUID] = room
	self.roomsCreated = { [roomName] = roomUUID }
	return room
end



function RoomController:removeRoom(roomName)
	if self.roomsCreated[roomName] then
		self.rooms[self.roomsCreated[roomName]] = nil
		self.roomsCreated[roomName] = nil
	end
	
end

return RoomController
