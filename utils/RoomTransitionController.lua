RoomTransitionController = Object:extend()



--[[
The idea is to create a transition between the room and the room to go, the idea is to make an in between transition to way
]]

function RoomTransitionController:new()
	self.currentRoom = nil
	self.rooms = {}
	self.roomTransition = {}
	if type(self.rooms) ~= "table" then
		print("Error: self.rooms is not a table. It might be nil.")
	else
		print("i am table")
	end
	self.roomsName = {}
end

function RoomTransitionController:update(dt)
	if self.currentRoom then
		self.currentRoom:update(dt)
	end
end

function RoomTransitionController:draw()
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

--[[
    -- Cause im persistent i need to chage this
    function gotoRoom(room_type, ...)
        if currentRoom and currentRoom.destroy then currentRoom:destroy() end
        currentRoom = _G[room_type](...)
    end

]]

function RoomTransitionController:gotoRoom(room_type, room_name, ...)
	print("room_type : ", room_type, " room_name : ", room_name)
	
	if self.currentRoom and self.rooms[room_name] then
		if self.currentRoom.deactivate then
			self.currentRoom:deactivate()
		end
		self.currentRoom = self.rooms[room_name]
		if self.currentRoom.activate then
			self.currentRoom:activate()
		end
	else
		self.currentRoom = self:addRoom(room_type, room_name, ...)
	end
end

function RoomTransitionController:addRoom(room_type, room_name, ...)
	local room = _G[room_type](room_name, ...)
	self.rooms[room_name] = room
	return room
end

function RoomTransitionController:addRoomTransition(roomEffect, roomTransitionName, ...)
	local room = _G[roomEffect](roomTransitionName, ...)
	self.roomTransition[roomEffect] = room
	return room
end


return RoomTransitionController
