# BOB (LÖVE2D Game)

## Overview

BOB is a fast-paced, top-down action game built with the [LÖVE2D](https://love2d.org/) framework. The game features dynamic enemies, a robust skill tree, collectible power-ups, and a modular, extensible codebase. The project is designed for easy expansion and learning, making it a great reference for LÖVE2D developers.

This game is based on [BYTEPATH](https://github.com/a327ex/BYTEPATH) tutorial

---

## Features

### Core Gameplay
- **Player Movement & Shooting**: Move with WASD, shoot in 8 directions using arrow keys.
- **Enemies**: Multiple enemy types (`Rock`, `BigRock`, `Shooter`) with unique behaviors and attack patterns.
- **Projectiles**: Diverse projectile types with modifiers like homing, splitting, bouncing, and more.
- **Power-ups & Coins**: Collect `Ammo`, `BoostCoin`, `HpCoin`, and `ResourceCoin` for upgrades and bonuses.
- **Skill Tree**: Unlock and upgrade stats via a branching skill tree system.
- **Room System**: Seamless transitions between different game rooms (e.g., Stage, Console, SkillTree).
- **Physics**: Uses [windfield](libraries/windfield/) for collision and physics simulation.
- **Visual Effects**: Includes effects like explosions, lightning, trails, and animated text.

### UI & Feedback
- **Animated Info Text**: Displays animated, glitchy text for feedback and notifications.
- **Circular Info Text**: Text effects that wrap around the player or objects.
- **Visual Feedback**: Flash effects, color changes, and particle effects for actions and events.

### Technical Features
- **Modular Structure**: Organized into folders by feature (e.g., `gameObjects`, `enemies`, `utils`).
- **Extensible GameObject System**: All entities inherit from a base `GameObject` class.
- **Timers & Animation**: Uses [hump.timer](libraries/hump/timer.lua) and custom timers for smooth animations.
- **Input Handling**: Customizable input via [boipushy](libraries/input/).
- **Resolution Handling**: Dynamic scaling and resolution management with [push](libraries/push/).
- **Utility Functions**: Includes helpers for math, table operations, and randomization.

---



### Key Directories

- **abstractGameObject/**: Core abstractions (`Area`, `Game`, `GameObject`, `Line`, `Node`).
- **enemies/**: Enemy types and their logic (`Rock`, `BigRock`, `Shooter`).
- **gameObjects/**: Collectibles, effects, player, projectiles, and UI elements.
- **gameObjectsEffect/**: Visual and gameplay effects (particles, explosions, etc).
- **metaGameObject/**: Meta-objects like `Enemy`, `EnemyProjectile`, `CoinObject`.
- **objectManagers/**: Managers for projectiles, stats, multipliers, etc.
- **rooms/**: Different game rooms/screens (e.g., `Stage`, `SkillTree`, `Console`).
- **utils/**: Utility scripts for room control, transitions, stats, and general helpers.
- **libraries/**: Third-party and custom libraries (physics, input, timers, etc).
- **resource/**: Fonts and shaders.
- **sound/**: Audio assets.

---

## Main Components

- **main.lua**: Entry point, sets up global variables, loads libraries, and initializes the game.
- **Loader.lua**: Dynamically loads files from directories.
- **conf.lua**: LÖVE2D configuration (window size, modules, etc).
- **globals.lua**: Global constants, color definitions, attack types, and achievements.

---

## How to Play

1. **Movement**: Use `WASD` to move the player.
2. **Shooting**: Use arrow keys to shoot in 8 directions.
3. **Collect**: Pick up coins and power-ups for bonuses.
4. **Upgrade**: Access the skill tree to unlock and upgrade stats.
5. **Survive**: Avoid enemy attacks and defeat as many as possible.

---

## How to Run

1. Install [LÖVE2D](https://love2d.org/).
2. Download or clone this repository.
3. Run the game with:
   ```sh
   love .
---

## Libraries Used

- **[classic](https://github.com/rxi/classic/)** - Simple OOP for Lua.
- **[hump](https://github.com/vrld/hump)** - Camera, timer, vector math, gamestate.
- **[windfield](https://github.com/a327ex/windfield)** - Physics and collision 
- **[moses](https://github.com/Yonaba/Moses)** Functional programming utilities.