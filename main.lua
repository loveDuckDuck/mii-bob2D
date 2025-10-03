-- in main.lua

Object = require("libraries/classic/classic")

Loader = require("Loader")
Input = require("libraries/input/Input")
Timer = require("libraries/enhanced_timer/EnhancedTimer")
Camera = require("libraries/hump/camera")
Push = require("libraries/push/push")
Draft = require("libraries/draft/draft")
Vector = require("libraries/hump/vector")
Physics = require("libraries/windfield")
Moses = require("libraries/moses/moses")
--utilities
Util = require("utils/Utils")
RoomController = require("utils/RoomController")
TreeLogic = require("utils/TreeStats")

require("libraries/string/utf8")
require("globals")


--Area = require 'gameObject/Area'

function flash(frames)
	FlashFrames = frames
end

function resize(s)
	love.window.setMode(s * gw, s * gh)
	sx, sy = s, s
end

function love.resize(w, h)
	Push.resize(w, h)
end

function love.draw()
	Push:start()
	DrawGarbageCollector()
	GlobalRoomController:draw()
	love.graphics.setColor(G_default_color)
	Push:finish()
end

function Slow(amount, duration)
	slow = amount
	print("slow : " .. slow)
	GTimer:tween("Slow", duration, _G, { slow = 1 }, "in-out-cubic")
end

function love.update(dt)
	if GInput:pressed("DeleteEveryThing") then
		DeleteEveryThing()
	end
	if GInput:pressed("goToTestingRoom") then
		GlobalRoomController:gotoRoom("TestingRoom", 1)
	end

	if GInput:pressed("goToSkillTree") then
		--CreateSkillTree("resource/input.png")

		GlobalRoomController:gotoRoom("SkillTree", 2)
	end

	GlobalRoomController:update(dt * slow)
	GCamera:update(dt * slow)
	GTimer:update(dt * slow)
end

local function graphicSetter()
	love.graphics.setDefaultFilter("nearest", "nearest")
	--love.graphics.setLineStyle("rough")
	Font = love.graphics.newFont("resource/m5x7.ttf")
	if Font then
		print("loaded")
		love.graphics.setNewFont(12)
	end
end

local function inputBinder()
	GInput = Input()

	GInput:bind("a", "left")
	GInput:bind("d", "right")
	GInput:bind("w", "up")

	GInput:bind("s", "down")
	GInput:bind("space", "boosting")

	GInput:bind("b", "b")


	GInput:bind("down", "shootdown")
	GInput:bind("up", "shootup")
	GInput:bind("left", "shootleft")
	GInput:bind("right", "shootright")

	GInput:bind("escape", "DeleteEveryThing")
	GInput:bind("wheelup", "zoomIn")
	GInput:bind("wheeldown", "zoomOut")

	GInput:bind("t", "goToTestingRoom")
	GInput:bind("k", "goToSkillTree")

	GInput:bind("wheelup", "zoomIn")
	GInput:bind("wheeldown", "zoomOut")
end

function love.load()
	graphicSetter()
	inputBinder()
	GDraft = Draft()
	GLoader = Loader()

	GLoader:getRequireFiles("abstractGameObject")
	GLoader:getRequireFiles("metaGameObject")
	GLoader:getRequireFiles("gameObjectsEffect")
	GLoader:getRequireFiles("enemies")
	GLoader:getRequireFiles("objectManagers")
	GLoader:getRequireFiles("gameObjects")
	GLoader:getRequireFiles("rooms")


	GTimer = Timer()
	GCamera = Camera()
	--GCamera.scale = 1
	GlobalRoomController = RoomController()

	GlobalRoomController:gotoRoom("Stage", UUID())
	--resize(2)
	slow = 1
	FlashFrames = 0

	Push:setupScreen(gw, gh, 640, 480, { resizible = true })
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
