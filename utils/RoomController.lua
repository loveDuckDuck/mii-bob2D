RoomController = Object:extend()

function RoomController:new()
	self.currentRoom = nil
	self.rooms = {}
	self.roomsCreated = {}
end

function RoomController:update(dt)
	if self.currentRoom then
		self.currentRoom:update(dt)
	end
end

function RoomController:draw()
	if self.currentRoom then
		self.currentRoom:draw()
	end
	if FlashFrames then
		FlashFrames = FlashFrames - 1
		if FlashFrames == -1 then
			FlashFrames = nil
		end
	end
	if FlashFrames then
		love.graphics.setColor(GBackgroundColor)
		love.graphics.rectangle("fill", 0, 0, SX * GW, SY * GH)
		love.graphics.setColor(255, 255, 255)
	end
end

function RoomController:goToRoomMenu(roomType, roomUUID, ...)
	print("roomType : ", roomType, " roomUUID : ", roomUUID)
	if self.currentRoom and self.rooms[roomUUID] then
		if self.currentRoom.deactivate then
			self.currentRoom:deactivate()
		end
		self.currentRoom = self.rooms[roomUUID]
		if self.currentRoom.activate then
			if self.currentRoom.bindInputs then
				self.currentRoom:bindInputs()
			end
			self.currentRoom:activate()
		end
	else
		self.currentRoom = self:addRoom(roomType, roomUUID, ...)
	end
end

function RoomController:gotoRoom(roomName, roomUUID, firstStart, ...)
	print("n : ", table.count(self.roomsCreated))
	if self.roomsCreated[roomName] then
		self:removeRoom(roomName)
	end

	print("roomName : ", roomName, " roomUUID : ", roomUUID)
	self.roomsCreated = { [roomName] = roomUUID }
	if self.currentRoom and self.rooms[roomUUID] then
		if self.currentRoom.deactivate then
			self.currentRoom:deactivate()
		end
		self.currentRoom = self.rooms[roomUUID]
		if self.currentRoom.activate then
			if self.currentRoom.bindInputs then
				self.currentRoom:bindInputs()
			end
			self.currentRoom:activate()
		end
	else
		self.currentRoom = self:addRoom(roomName, roomUUID, ...)
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
		self.rooms[self.roomsCreated[roomName]]:destroy()
		table.clear(self.rooms[self.roomsCreated[roomName]])
		self.rooms[self.roomsCreated[roomName]] = nil
		self.roomsCreated[roomName] = nil
	end
end

function RoomController:__tostring()
	return "RoomController"
end

return RoomController
