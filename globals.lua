Attacks = {
	["Neutral"] = {
		name = "Neutral",
		cooldown = 0.24,
		damage = 2,
		ammo = 0,
		tears = 1,
		abbreviation = "N",
		color = { 1.0, 0.9921, 0.8115, 1.0 },
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
	},
	["Rapid"] = {
		name = "Rapid",
		damage = 1,
		cooldown = 0.10,
		ammo = 1,
		tears = 1,
		abbreviation = "R",
		color = { 1.0, 0.98, 0.80, 1.00 },

	},
	["Homing"] = {
		name = "Homing",
		damage = 3,
		cooldown = 0.50,
		ammo = 1,
		tears = 1,
		abbreviation = "Ho",
		color = { 0.5632, 0.8722, 0.1111, 1.00 }, -- rgb(252, 216, 205)

	},
	["Spread"] = {
		name = "Spread",
		damage = 2,
		cooldown = 1,
		ammo = 4,
		tears = 1,
		abbreviation = "SP",
		color = { 0.3711, 0.1210, 0.9678, 1.00 }, -- rgb(252, 216, 205)

	},
	["Back"] = {
		name = "Back",
		damage = 2,
		cooldown = 1,
		ammo = 4,
		tears = 1,
		abbreviation = "BK",
		color = { 0.7755, 0.9211, 0.1633, 1.00 }, -- rgb(252, 216, 205)

	},
	["Side"] = {
		name = "Side",
		damage = 2,
		cooldown = 1.2,
		ammo = 4,
		tears = 1,
		abbreviation = "SD",
		color = { 0.8811, 0.5678, 0.3409, 1.00 }, -- rgb(252, 216, 205)

	},

	["Destroyer"] = {
		name = "Destroyer",
		damage = 2,
		cooldown = 1.2,
		ammo = 4,
		tears = 1,
		abbreviation = "DKILL",
		color = { 1.00, 1.00, 1.00, 1.00 }, -- rgb(252, 216, 205)

	},
	["Blast"] = {
		name = "Blast",
		damage = 2,
		cooldown = 0.64,
		ammo = 6,
		tears = 1,
		abbreviation = "BIG BOY BLAST",
		color = { 0.6542, 0.1675, 1.00, 1.00 }, -- rgb(252, 216, 205)

	},
	["Spin"] = {
		name = "Spin",
		damage = 2,
		cooldown = 0.32,
		ammo = 2,
		tears = 1,
		abbreviation = "G.I ROBOT",
		color = { 0.9222, 0.1675, 0.3287, 1.00 }, -- rgb(252, 216, 205)

	},
	["Hearth"] = {
		name = "Hearth",
		damage = 2,
		cooldown = 0.32,
		ammo = 2,
		tears = 1,
		abbreviation = "mi love for you",
		color = { 1.9, 0.1675, 0.3287, 1.00 }, -- rgb(252, 216, 205)
	},
	["Flame"] = {
		name = "Flame",
		damage = 2,
		cooldown = 0.048,
		ammo = 0.4,
		tears = 1,
		abbreviation = "THE BRIDE",
		color = { 0.1, 1.0, 0.3287, 1.00 }, -- rgb(252, 216, 205)
	},

	["Bounce"] = {
		name = "Bounce",
		damage = 2,
		cooldown = 0.048,
		ammo = 0.4,
		tears = 1,
		abbreviation = "ASS BOUNCE ???",
		color = { 0.1, 1.0, 0.3287, 1.00 }, -- rgb(252, 216, 205)
	},

	["2Split"] = {
		name = "2Split",
		damage = 2,
		cooldown = 0.32,
		ammo = 3,
		tears = 1,
		abbreviation = "TWO BITCHIESSSS",
		color = { 0.1, 1.0, 0.3287, 1.00 }, -- rgb(252, 216, 205)
	},
	["4Split"] = {
		name = "4Split",
		damage = 2,
		cooldown = 0.4,
		ammo = 4,
		tears = 1,
		abbreviation = "GANG BANG",
		color = { 0.31, 0.0, 0.3287, 1.00 }, -- rgb(252, 216, 205)
	},
	["Lightning"] = {
		name = "Lightning",
		damage = 0.05,
		cooldown = 0.05,
		ammo = 0,
		tears = 1,
		abbreviation = "Ka-chow!",
		color = { 1.0, 1.0, 1.0, 1.00 }, -- rgb(252, 216, 205)
	},
	["Explode"] = {
		name = "Explode",
		damage = 0.05,
		cooldown = 0.5,
		ammo = 0,
		tears = 1,
		abbreviation = "BOOOOOYAAA",
		color = { 1, 0, 0, 1.00 }, -- rgb(252, 216, 205)

	},
}
Enemies = { "Rock", "Shooter" }


Achievements = {
	['10K Fighter'] = {
		name = "10K Fighter",
		description = "Reach 10,000 score in a single run.",
		color = { 1.0, 0.84, 0.0, 1.0 },
		unlocked = false,

	}
}

GDefaultColor = { 0.87, 1, 0.81, 1.0 }
GBackgroundColor = { 0.06, 0.06, 0.06, 1.0 }
GAmmoColor = { 0.48, 0.78, 0.64, 1.0 }
GBoostColor = { 0.29, 0.76, 0.85, 1.0 }
GHPColor = { 0.94, 0.40, 0.27, 1.0 }
GSkillPointColor = { 1.0000, 0.7765, 0.3647, 1.0 }
GWhiteCream = { 1.0, 0.9921, 0.8115, 1 }

G_default_player_velocity = 300
GDefaultColors = { GDefaultColor, GHPColor, GAmmoColor, GBoostColor, GSkillPointColor }

G_negative_colors = {
	{ 1 - GDefaultColor[1],    1 - GDefaultColor[2],    1 - GDefaultColor[3] },
	{ 1 - GHPColor[1],         1 - GHPColor[2],         1 - GHPColor[3] },
	{ 1 - GAmmoColor[1],       1 - GAmmoColor[2],       1 - GAmmoColor[3] },
	{ 1 - GBoostColor[1],      1 - GBoostColor[2],      1 - GBoostColor[3] },
	{ 1 - GSkillPointColor[1], 1 - GSkillPointColor[2], 1 - GSkillPointColor[3] },
}
