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
		love.graphics.setColor(GBackgroundColor)
		love.graphics.rectangle("fill", 0, 0, SX * GW, SY * GH)
		love.graphics.setColor(255, 255, 255)
	end
end

function RoomController:goToRoomMenu(roomType, roomUUID, ...)
	print("roomType : ", roomType, " roomUUID : ", roomUUID)
	if self.current_room and self.rooms[roomUUID] then
		if self.current_room.deactivate then
			self.current_room:deactivate()
		end
		self.current_room = self.rooms[roomUUID]
		if self.current_room.activate then
			if self.current_room.bindInputs then
				self.current_room:bindInputs()
			end
			self.current_room:activate()
		end
	else
		self.current_room = self:addRoom(roomType, roomUUID, ...)
	end
end

function RoomController:gotoRoom(roomName, roomUUID, ...)
	print("n : ", table.count(self.roomsCreated))
	print("roomName : ", roomName, " roomUUID : ", roomUUID)
	self.roomsCreated = { [roomName] = roomUUID }
	if self.current_room and self.rooms[roomUUID] then
		if self.current_room.deactivate then
			self.current_room:deactivate()
		end
		self.current_room = self.rooms[roomUUID]
		if self.current_room.activate then
			if self.current_room.bindInputs then
				self.current_room:bindInputs()
			end
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
		destroyAllTable(self.rooms[self.roomsCreated[roomName]])
		self.rooms[self.roomsCreated[roomName]] = nil
		self.roomsCreated[roomName] = nil
	end
end

function destroyAllTable(t)
	for k, v in pairs(t) do
		if type(v) == "table" then
			destroyAllTable(v)
			if t[k].destroy then
				t[k]:destroy()
			end
			t[k] = nil
		else
			t[k] = nil
		end
	end
end

function RoomController:__tostring()
	return "RoomController"
end

return RoomController
