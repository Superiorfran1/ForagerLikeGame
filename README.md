# Forager (Jaén Game Jam)
 
2D video game prototype inspired by **Forager**, developed with the **Godot Engine (4.6)** during the **Jaén Game Jam**.
 
> ⚠️ **Status: unfinished project.** It was built under the time constraints of a game jam, so several mechanics are incomplete or not fully polished. It's shared here as a showcase of the work done during the event, not as a finished game.
 
## 🎮 About the project
 
Forager is a resource-gathering and crafting game where the player explores different biomes, collects resources, turns them into tools and materials, and interacts with several NPCs, each specialized in a different trade.
 
## 🧩 Implemented mechanics
 
- **Movement and animation** of the character (idle / walk) in all 4 directions
- **Resource gathering**: trees, bushes and rocks, each with its own interaction script
- **Basic inventory system**: pick up and drop a single item with the `E` key
- **Crafting stations**: workbench, anvil and furnace, each with its own crafting logic
- **Interactive NPCs**: blacksmith, miner, mage and archaeologist
- **Equippable tools**: axe and pickaxe, each with their own usage animations
- **Special item (compass)**: used with left click
- **3 playable biomes**: forest, meadow and desert, each with its own tileset
## 🎹 Controls
 
| Action | Key |
|---|---|
| Move | `W` `A` `S` `D` |
| Hit / use tool | Left click |
| Open inventory / pick up / drop / craft | `E` |
 
## 🛠️ Technologies used
 
- **Godot Engine 4.6** (GDScript)
- GL Compatibility renderer (works on low/mid-end hardware)
- Custom/adapted sprites and tilesets for each biome
## 📁 Project structure
 
```
├── Personaje/         # Player, tools and animations
├── Objetos/            # Trees, bushes, rocks and pickup items
├── npc/                # Blacksmith, miner, mage and archaeologist
├── mesas/              # Crafting stations (workbench, anvil, furnace)
├── escenas/            # Biome scenes (forest, meadow, desert)
├── tileMap/            # Tilesets for each biome
├── sprites/             # Graphic assets
├── animaciones/        # Animation resources (SpriteFrames)
├── fonts/              # In-game font
└── project.godot       # Godot project configuration
```
 
## 🚀 How to run it
 
1. Download and install [Godot Engine 4.6](https://godotengine.org/download) (or a compatible newer version).
2. Clone this repository:
```bash
   git clone https://github.com/Superiorfran1/forager.git
```
3. Open Godot, select **Import**, and pick the project folder (`project.godot`).
4. Press **Run** (▶) to try it out.
## 🔧 To-do / future improvements
 
- Polish and balance the crafting system
- Add more recipes and resources
- Save game system
- Sound and music
- Main menu and pause screen
- Fix potential collision and NPC interaction bugs
## 👤 Author
 
**Francisco Cantero Maestro**
- GitHub: [@Superiorfran1](https://github.com/Superiorfran1)
- Email: franciscocm1000@gmail.com
---
 
Project developed for learning purposes in the context of the Jaén Game Jam.
