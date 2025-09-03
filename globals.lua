Attacks = {
	["Neutral"] = {
		name = "Neutral",
		cooldown = 0.24,
		ammo = 0,
		abbreviation = "N",
		color = { 1.0, 0.9921, 0.8115, 1.0 },
		resource = function(x, y, w, h)
			DraftDrawer:rhombus(x, y, w, h, "line")
			DraftDrawer:lozenge(x + 5, y + 5, w, "line")
		end,
	},
	["Double"] = {
		name = "Double",
		cooldown = 0.32,
		ammo = 2,
		abbreviation = "2",
		color = { 0.29, 0.76, 0.85, 1.0 },
		resource = function(x, y, w, h)
			DraftDrawer:rhombus(x, y, w, h, "line")
			DraftDrawer:diamond(x + 5, y + 5, w, "line")
		end,
	},
	["Triple"] = {
		name = "Triple",

		cooldown = 0.40,
		ammo = 5,
		abbreviation = "3",
		color = { 0.98, 0.80, 0.80, 1.00 },
		resource = function(x, y, w, h)
			DraftDrawer:rhombus(x, y, w, h, "line")
			DraftDrawer:rhombusEquilateral(x + 5, y + 5, w, "line")
		end,
	},
	["Rapid"] = {
		name = "Rapid",

		cooldown = 0.10,
		ammo = 1,
		abbreviation = "R",
		color = { 1.0, 0.98, 0.80, 1.00 },
		resource = function(x, y, w, h)
			DraftDrawer:rhombus(x, y, w, h, "line")
			DraftDrawer:kite(x + 5, y + 5, w, h, w, "line")
		end,
	},
}
