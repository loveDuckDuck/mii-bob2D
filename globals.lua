Attacks = {
	["Neutral"] = {
		name = "Neutral",
		cooldown = 0.24,
		damage = 2,
		ammo = 0,
		abbreviation = "N",
		color = { 1.0, 0.9921, 0.8115, 1.0 },
		resource = function(x, y, w, h)
			DraftDrawer:lozenge(x, y, w + 5, "line")
		end,
	},
	["Double"] = {
		name = "Double",
		cooldown = 0.32,
		damage = 4,
		ammo = 2,
		abbreviation = "2",
		color = { 0.29, 0.76, 0.85, 1.0 },
		resource = function(x, y, w, h)
			DraftDrawer:diamond(x, y, w + 5, "line")
		end,
	},
	["Triple"] = {
		name = "Triple",
		damage = 12,
		cooldown = 0.40,
		ammo = 5,
		abbreviation = "3",
		color = { 0.98, 0.80, 0.80, 1.00 },
		resource = function(x, y, w, h)
			DraftDrawer:rhombusEquilateral(x, y, w + 10, "line")
		end,
	},
	["Rapid"] = {
		name = "Rapid",
		damage = 1,
		cooldown = 0.10,
		ammo = 1,
		abbreviation = "R",
		color = { 1.0, 0.98, 0.80, 1.00 },
		resource = function(x, y, w, h)
			DraftDrawer:kite(x, y, w + 5, h + 5, w, "line")
		end,
	},
	["Homing"] = {
		name = "Homing",
		damage = 3,
		cooldown = 0.50,
		ammo = 1,
		abbreviation = "Ho",
		color = { 252 / 255, 216 / 255, 205 / 255, 1.00 }, -- rgb(252, 216, 205)
		resource = function(x, y, w, h)
			DraftDrawer:diamond(x, y, w + 5, h + 5, w, "line")
		end,
	},
}
Enemies = { "Rock", "Shooter" }
