Attacks = {
	["Neutral"] = {
		name = "Neutral",
		cooldown = 0.24,
		damage = 2,
		ammo = 0,
		tears = 1,
		abbreviation = "N",
		color = { 1.0, 0.9921, 0.8115, 1.0 },
		resource = function(x, y, w)
			DraftDrawer:circle(x, y, w + 10 , nil,"line")
		end,
	},
	["Double"] = {
		name = "Double",
		cooldown = 0.32,
		damage = 4,
		ammo = 2,
		tears = 2,
		shootAngle = math.pi / 12,

		abbreviation = "2",
		color = { 0.29, 0.76, 0.85, 1.0 },
		resource = function(x, y, w)
			DraftDrawer:circle(x, y, w + 5,  nil,"line")
		end,
	},
	["Triple"] = {
		name = "Triple",
		damage = 12,
		cooldown = 0.40,
		ammo = 5,
		tears = 3,
		shootAngle = math.pi / 4,
		abbreviation = "3",
		color = { 0.98, 0.80, 0.80, 1.00 },
		resource = function(x, y, w)
			DraftDrawer:circle(x, y, w + 10,  nil, "line")
		end,
	},
	["Rapid"] = {
		name = "Rapid",
		damage = 1,
		cooldown = 0.10,
		ammo = 1,
		tears = 1,
		abbreviation = "R",
		color = { 1.0, 0.98, 0.80, 1.00 },
		resource = function(x, y, w)
			DraftDrawer:circle(x, y, w + 5,  nil, "line")
		end,
	},
	["Homing"] = {
		name = "Homing",
		damage = 3,
		cooldown = 0.50,
		ammo = 1,
		tears = 1,
		abbreviation = "Ho",
		color = { 0.5632, 0.8722, 0.1111, 1.00 }, -- rgb(252, 216, 205)
		resource = function(x, y, w)
			DraftDrawer:circle(x, y, w + 5,  nil,"line")
		end,
	},
	["Spread"] = {
		name = "Spread",
		damage = 2,
		cooldown = 1,
		ammo = 4,
		tears = 1,
		abbreviation = "SP",
		color = { 0.3711, 0.1210, 0.9678, 1.00 }, -- rgb(252, 216, 205)
		resource = function(x, y, w)
			DraftDrawer:circle(x, y, w + 5, nil, "line")
		end,
	},
	["Back"] = {
		name = "Back",
		damage = 2,
		cooldown = 1,
		ammo = 4,
		tears = 1,
		abbreviation = "BK",
		color = { 0.7755, 0.9211, 0.1633, 1.00 }, -- rgb(252, 216, 205)
		resource = function(x, y, w)
			DraftDrawer:circle(x, y, w + 5,  nil,"line")
		end,
	},
	["Side"] = {
		name = "Side",
		damage = 2,
		cooldown = 1.2,
		ammo = 4,
		tears = 1,
		abbreviation = "SD",
		color = { 0.8811, 0.5678, 0.3409, 1.00 }, -- rgb(252, 216, 205)
		resource = function(x, y, w)
			DraftDrawer:circle(x, y, w + 5, nil, "line")
		end,
	},
	--[[ 
		XXX: make following???
	--]]
	["Destroyer"] = {
		name = "Destroyer",
		damage = 100,
		cooldown = 1.2,
		ammo = 4,
		tears = 1,
		abbreviation = "DKILL",
		color = { 1.00, 1.00, 1.00, 1.00 }, -- rgb(252, 216, 205)
		resource = function(x, y, w, h)
			DraftDrawer:star(x, y, w * 10, w * 5, w * 2, w)
		end,
	},
}
Enemies = { "Rock", "Shooter" }
