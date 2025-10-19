-- in main.lua

Object         = require("libraries/classic/classic")

Loader         = require("Loader")
Input          = require("libraries/input/Input")
Timer          = require("libraries/enhanced_timer/EnhancedTimer")
Camera         = require("libraries/hump/camera")
Draft          = require("libraries/draft/draft")
Vector         = require("libraries/hump/vector")
Physics        = require("libraries/windfield")
Moses          = require("libraries/moses/moses")

--utilities
Util           = require("utils/Utils")
RoomController = require("utils/RoomController")
TreeLogic      = require("utils/TreeStats")

require("libraries/string/utf8")
require("globals")


--Bitser = require 'bitser'

--Area = require 'gameObject/Area'

function flash(frames)
	FlashFrames = frames
end

--[[

	TODO : save and load game

]]
-- function love.save()
-- 	local save_data = {}
-- 	-- Set all save data here
-- 	Bitser.dumpLoveFile('save', save_data)
-- end

-- function load()
-- 	if love.filesystem.exists('save') then
-- 		local save_data = bitser.loadLoveFile('save')
-- 		-- Load all saved data here
-- 	else
-- 		FirstRunEver = true
-- 	end
-- end

function resizeWidthHeight(w, h)
	love.window.setMode(w, h)
	SX, SY = love.graphics.getWidth() / GW, love.graphics.getHeight() / GH
	print("Resized to: " .. w .. "x" .. h .. "  SX: " .. SX .. " SY: " .. SY)
	RES_X, RES_Y = w, h
end

function resize(s)
	love.window.setMode(s * GW, s * GH)
	SX, SY = s, s
end

function love.draw()
	--DrawGarbageCollector()
	GRoom:draw()
	GameTracker:draw()
	--Prof:draw()
	-- local y_offset = 0
	-- local x_offset = 0

	-- for _, value in pairs(data.items) do
	-- 	for _, ivalue in pairs(value) do
	-- 		if type(ivalue) ~= "table" then
	-- 			love.graphics.print(_ .. ": " .. ivalue, x_offset, y_offset)
	-- 			y_offset = y_offset + 20 -- Increment the y-coordinate for the next line
	-- 			if y_offset > RES_Y then
	-- 				print(y_offset)
	-- 				x_offset = x_offset + 300
	-- 				y_offset = 0
	-- 			end
	-- 		end
	-- 	end
	-- end
end

-- in main.lua
function love.textinput(t)
	if GRoom.currentRoom.textinput then GRoom.currentRoom:textinput(t) end
end

function love.update(dt)

	if GInput:pressed("DeleteEveryThing") then
		DeleteEveryThing()
	end
	if GInput:pressed("goToStage") then
		GRoom:gotoRoom("Stage", 1) -- XXX : fiX
	end
	if GInput:pressed("goToConsole") then
		GRoom:gotoRoom("Console", 3)
	end

	if GInput:pressed("goToSkillTree") then
		GRoom:gotoRoom("SkillTree", 2)
	end

	GCamera:update(dt * slow)
	GTimer:update(dt * slow)
	GRoom:update(dt * slow)
	GameTracker:update(dt * slow)
	--Prof:detach()
	--data = Prof:unpack()
end

local function graphicSetter()
	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.graphics.setLineStyle('rough')
	love.graphics.setBackgroundColor(GBackgroundColor)
	GFont = love.graphics.newFont("resource/font/m5x7.ttf", 16)
	if GFont then
		GFont:setFilter("nearest", "nearest")
		love.graphics.setFont(GFont)
	end
end

local function inputBinder()
	GInput:bind("escape", "DeleteEveryThing")

	GInput:bind("f1", "goToSkillTree")
	GInput:bind("f2", "goToConsole")
	GInput:bind("f3", "goToStage")

	GInput:bind("a", "left")
	GInput:bind("d", "right")
	GInput:bind("w", "up")
	GInput:bind("s", "down")

	GInput:bind("down", "shootdown")
	GInput:bind("up", "shootup")
	GInput:bind("left", "shootleft")
	GInput:bind("right", "shootright")

	GInput:bind("space", "boosting")

	GInput:bind("wheelup", "zoomIn")
	GInput:bind("wheeldown", "zoomOut")
end

function InputBinderPlayerControls()
	GInput:unbindAll()
end

function InputBinderSkillTree()
	GInput:unbindAll()
end

function love.load()
	GInput = Input()
	inputBinder()
	graphicSetter()
	GDraft = Draft()
	GLoader = Loader()

	GLoader:getRequireFiles("abstractGameObject")
	GLoader:getRequireFiles("metaGameObject")
	GLoader:getRequireFiles("gameObjectsEffect")
	GLoader:getRequireFiles("enemies")
	GLoader:getRequireFiles("objectManagers")
	GLoader:getRequireFiles("gameObjects")
	GLoader:getRequireFiles("modules")
	GLoader:getRequireFiles("rooms")

	GameTracker = Game()
	GameTracker:init()
	GTimer = Timer()
	GCamera = Camera()
	GRoom = RoomController()
	print(GRoom)
	GRoom:gotoRoom("Stage", 1) -- XXX : fix
	slow = 1
	FlashFrames = 0
	resizeWidthHeight(1280, 720)
end

function love.run()
	local dt

	if love.math then -- check if love.math is nil, because we need it
		love.math.setRandomSeed(os.time())
	end

	if love.load then
		love.load()
	end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then
		love.timer.step()
		dt = love.timer.getDelta() -- with this im gone insert define the fixed delta time
	end

	-- Main loop time.
	while true do
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a, b, c, d, e, f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a
					end
				end
				love.handlers[name](a, b, c, d, e, f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then
			love.timer.step()
			dt = love.timer.getDelta()
		end

		-- Call update and draw
		if love.update then
			love.update(dt)
		end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.clear(love.graphics.getBackgroundColor())
			love.graphics.origin()
			if love.draw then
				love.draw()
			end
			love.graphics.present()
		end

		if love.timer and (love.window.getVSync() == 0) then
			-- print("nos sleep")
			love.timer.sleep(0.001)
		else
			--print("vSync enabled")
		end
	end
end
