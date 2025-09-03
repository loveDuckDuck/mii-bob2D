gw = 640
gh = 480

GlobalWordlSizeX = 2000
GlobalWordlSizeY = 2000

--gw = 720
--gh = 360

sx = 1
sy = 1

function love.conf(t)
	t.identity = nil -- The name of the save directory (string)
	t.version = "11.5" -- The LÖVE version this game was made for (string)
	t.console = false -- Attach a console (boolean, Windows only)

	t.window.title = "BYTEPATH" -- The window title (string)
	t.window.icon = nil -- Filepath to an image to use as the window's icon (string)
	t.window.width = gw -- The window width (number)
	t.window.height = gh -- The window height (number)
	t.window.borderless = false -- Remove all border visuals from the window (boolean)
	t.window.resizable = true -- Let the window be user-resizable (boolean)
	t.window.minwidth = 1 -- Minimum window width if the window is resizable (number)
	t.window.minheight = 1 -- Minimum window height if the window is resizable (number)
	t.window.fullscreen = false -- Enable fullscreen (boolean)
	t.window.fullscreentype = "exclusive" -- Standard fullscreen or desktop fullscreen mode (string)
	t.window.vsync = true -- Enable vertical sync (boolean)
	t.window.fsaa = 0 -- The number of samples to use with multi-sampled antialiasing (number)
	t.window.display = 1 -- Index of the monitor to show the window in (number)
	t.window.highdpi = false -- Enable high-dpi mode for the window on a Retina display (boolean)
	t.window.srgb = false -- Enable sRGB gamma correction when drawing to the screen (boolean)
	t.window.x = nil -- The x-coordinate of the window's position in the specified display (number)
	t.window.y = nil -- The y-coordinate of the window's position in the specified display (number)

	t.modules.audio = true -- Enable the audio module (boolean)
	t.modules.event = true -- Enable the event module (boolean)
	t.modules.graphics = true -- Enable the graphics module (boolean)
	t.modules.image = true -- Enable the image module (boolean)
	t.modules.joystick = true -- Enable the joystick module (boolean)
	t.modules.keyboard = true -- Enable the keyboard module (boolean)
	t.modules.math = true -- Enable the math module (boolean)
	t.modules.mouse = true -- Enable the mouse module (boolean)
	t.modules.physics = true -- Enable the physics module (boolean)
	t.modules.sound = true -- Enable the sound module (boolean)
	t.modules.system = true -- Enable the system module (boolean)
	t.modules.timer = true -- Enable the timer module (boolean), Disabling it will result 0 delta time in love.update
	t.modules.window = true -- Enable the window module (boolean)
	t.modules.thread = true -- Enable the thread module (boolean)

	G_default_color = { 0.31, 1, 0.81, 1.0 }
	G_background_color = { 0.06, 0.06, 0.06, 1.0 }
	G_ammo_color =  {1.0,0.0,0.0,1.0}--{ 0.48, 0.78, 0.64, 1.0 }
	G_boost_color = { 0.29, 0.76, 0.85, 1.0 }
	G_hp_color = { 0.94, 0.40, 0.27, 1.0 }
	G_skill_point_color = { 1.0000, 0.7765, 0.3647, 1.0 }
	G_white_cream = {1.0, 0.9921, 0.8115,1}

	G_random_characters = "0123456789!@#$%¨&*()-=+[]^~/;?><.,|abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWYXZ"
	G_default_player_velocity = 300
	G_default_colors = { G_default_color, G_hp_color, G_ammo_color, G_boost_color, G_skill_point_color }

	G_negative_colors = {
		{ 1 - G_default_color[1], 1 - G_default_color[2], 1 - G_default_color[3] },
		{ 1 - G_hp_color[1], 1 - G_hp_color[2], 1 - G_hp_color[3] },
		{ 1 - G_ammo_color[1], 1 - G_ammo_color[2], 1 - G_ammo_color[3] },
		{ 1 - G_boost_color[1], 1 - G_boost_color[2], 1 - G_boost_color[3] },
		{ 1 - G_skill_point_color[1], 1 - G_skill_point_color[2], 1 - G_skill_point_color[3] },
	}

	-- Const value for the coin object
	COIN_MIN_RANDOM_ROTATION = 0
	COIN_MAX_RANDOM_ROTATION = 2 * math.pi
	COIN_MIN_RANDOM_VELOCITY = 10
	COIN_MAX_RANDOM_VELOCITY = 20

	COIN_BASE_VALUE = 5
	COIN_ANGULAR_IMPULSE = 24
end
