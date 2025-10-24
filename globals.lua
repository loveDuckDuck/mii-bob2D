--[[ 
  Attacks Table:
  Contains definitions for various attack types, including their properties
  such as damage, cooldown, ammo usage, and visual representation.
--]]
Attacks = {
    -- Neutral attack: Basic attack with no ammo cost
    ["Neutral"] = {
        name = "Neutral",
        cooldown = 0.24,
        damage = 2,
        ammo = 0,
        tears = 1,
        abbreviation = "N",
        color = { 1.0, 0.9921, 0.8115, 1.0 },
    },

    -- Double attack: Fires two projectiles at a slight angle
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

    -- Triple attack: Fires three projectiles in a spread
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

    -- Rapid attack: Fast-firing attack with low damage
    ["Rapid"] = {
        name = "Rapid",
        damage = 1,
        cooldown = 0.10,
        ammo = 1,
        tears = 1,
        abbreviation = "R",
        color = { 1.0, 0.98, 0.80, 1.00 },
    },

    -- Homing attack: Projectiles that home in on targets
    ["Homing"] = {
        name = "Homing",
        damage = 3,
        cooldown = 0.50,
        ammo = 1,
        tears = 1,
        abbreviation = "Ho",
        color = { 0.5632, 0.8722, 0.1111, 1.00 },
    },

    -- Spread attack: Fires multiple projectiles in a wide arc
    ["Spread"] = {
        name = "Spread",
        damage = 2,
        cooldown = 1,
        ammo = 4,
        tears = 1,
        abbreviation = "SP",
        color = { 0.3711, 0.1210, 0.9678, 1.00 },
    },

    -- Back attack: Fires projectiles backward
    ["Back"] = {
        name = "Back",
        damage = 2,
        cooldown = 1,
        ammo = 4,
        tears = 1,
        abbreviation = "BK",
        color = { 0.7755, 0.9211, 0.1633, 1.00 },
    },

    -- Side attack: Fires projectiles to the sides
    ["Side"] = {
        name = "Side",
        damage = 2,
        cooldown = 1.2,
        ammo = 4,
        tears = 1,
        abbreviation = "SD",
        color = { 0.8811, 0.5678, 0.3409, 1.00 },
    },

    -- Destroyer attack: High-damage attack with long cooldown
    ["Destroyer"] = {
        name = "Destroyer",
        damage = 100,
        cooldown = 1.2,
        ammo = 4,
        tears = 1,
        abbreviation = "DKILL",
        color = { 1.00, 1.00, 1.00, 1.00 },
    },

    -- Additional attacks (Blast, Spin, Hearth, etc.)
    -- These follow the same structure as above
    ["Blast"] = { ... },
    ["Spin"] = { ... },
    ["Hearth"] = { ... },
    ["Flame"] = { ... },
    ["Bounce"] = { ... },
    ["2Split"] = { ... },
    ["4Split"] = { ... },
    ["Lightning"] = { ... },
    ["Explode"] = { ... },
}

--[[ 
  Enemies Table:
  Contains a list of enemy types present in the game.
--]]
Enemies = { "Rock", "Shooter", "BigRock" }

--[[ 
  Achievements Table:
  Contains definitions for achievements, including their name, description,
  and unlock status.
--]]
Achievements = {
    ['10K Fighter'] = {
        name = "10K Fighter",
        description = "Reach 10,000 score in a single run.",
        color = { 1.0, 0.84, 0.0, 1.0 },
        unlocked = false,
    }
}

--[[ 
  Global Colors:
  Defines various colors used throughout the game for UI elements.
--]]
GDefaultColor = { 0.87, 1, 0.81, 1.0 }
GBackgroundColor = { 0.06, 0.06, 0.06, 1.0 }
GAmmoColor = { 0.48, 0.78, 0.64, 1.0 }
GBoostColor = { 0.29, 0.76, 0.85, 1.0 }
GHPColor = { 0.94, 0.40, 0.27, 1.0 }
GSkillPointColor = { 1.0000, 0.7765, 0.3647, 1.0 }
GWhiteCream = { 1.0, 0.9921, 0.8115, 1 }

--[[ 
  Default Player Settings:
  Contains default values for player attributes such as velocity.
--]]
G_default_player_velocity = 300

--[[ 
  Color Collections:
  Groups of colors for easier access and manipulation.
--]]
GDefaultColors = { GDefaultColor, GHPColor, GAmmoColor, GBoostColor, GSkillPointColor }

-- Negative colors (inverted colors for effects)
G_negative_colors = {
    { 1 - GDefaultColor[1],    1 - GDefaultColor[2],    1 - GDefaultColor[3] },
    { 1 - GHPColor[1],         1 - GHPColor[2],         1 - GHPColor[3] },
    { 1 - GAmmoColor[1],       1 - GAmmoColor[2],       1 - GAmmoColor[3] },
    { 1 - GBoostColor[1],      1 - GBoostColor[2],      1 - GBoostColor[3] },
    { 1 - GSkillPointColor[1], 1 - GSkillPointColor[2], 1 - GSkillPointColor[3] },
}