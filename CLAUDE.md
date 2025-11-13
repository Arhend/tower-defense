# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a tower defense game built with Godot 4.5 using GDScript. The project uses a mobile rendering method and 2D navigation system.

## Running the Project

Open the project in Godot Engine 4.5+ and press F5 to run. The main scene is defined in [project.godot](project.godot:14).

## Architecture

### Singleton Pattern (Autoloads)

Two singletons manage global state:
- **SceneManager** ([Singletons/scene_manager.gd](Singletons/scene_manager.gd)) - Handles scene transitions
- **SignalManager** ([Singletons/signal_manager.gd](Singletons/signal_manager.gd)) - Central hub for game signals (`on_enemy_reached_exit`, `on_all_lives_lost`)

### Service-Oriented Level Design

Levels ([Scenes/Levels/base_level.gd](Scenes/Levels/base_level.gd)) use a service architecture with child service nodes:
- **EnemyPoolingService** - Object pooling for enemies to optimize performance
- **LifeManagementService** - Tracks player lives and listens to SignalManager events
- **DebugService** - Development utilities

### Inheritance Hierarchy

- **BaseEnemy** ([Scenes/Enemies/base_enemy.gd](Scenes/Enemies/base_enemy.gd)) - Base class for all enemies
  - Uses `activate()`/`deactivate()` pattern for pooling
  - Extends Area2D and uses NavigationAgent2D for pathfinding
  - Must be in "enemy" global group

- **BaseTower** ([Scenes/Towers/base_tower.gd](Scenes/Towers/base_tower.gd)) - Base class for all towers
  - Area2D with attack range detection
  - Tracks enemies via area enter/exit signals

### Object Pooling System

The EnemyPoolingService ([Scenes/Levels/enemy_pooling_service.gd](Scenes/Levels/enemy_pooling_service.gd)) pre-instantiates enemies and reuses them:
- Pre-creates `initial_size` enemies on ready
- Tracks usage via `enemy.in_use` flag
- Expands pool dynamically if needed
- Enemies must implement `activate()` and `deactivate()` methods

### Navigation System

- Navigation layers defined in project settings (layer 1: "ground")
- EnemyNavigationPoints ([Scenes/EnemyNavigationPoints/enemy_navigation_points.gd](Scenes/EnemyNavigationPoints/enemy_navigation_points.gd)) provides spawn and exit positions
- Enemies use NavigationAgent2D for pathfinding between spawn and exit

### Physics Layers

- Layer 1: "tower"
- Layer 2: "enemy"

## Code Patterns

When creating new enemies:
1. Extend BaseEnemy
2. Add to "enemy" global group
3. Implement any additional behavior in subclass
4. Update EnemyPoolingService constant if needed

When creating new towers:
1. Extend BaseTower (Area2D)
2. Configure attack_range and attack_speed exports
3. Implement attack logic using enemies_in_range array

### Command: Minimal Code Change

**Goal:** Make the smallest possible code edits to address my specific request, while building and showing a clear understanding of the existing system.

**When to use:** Any time I ask you to fix a bug, adjust behavior, or add a small feature/refactor to an existing codebase.

**Rules:**
1. **Minimal diffs only**
   - Change as little code as possible.
   - Do *not* restructure files, rename things, or “clean up” code unless I explicitly ask.
   - Prefer localized edits (a few lines or a small function) over touching many files.

2. **Show you understand the system**
   - Start by briefly summarizing what you think the relevant part of the system does (1–3 sentences).
   - Call out any assumptions you’re making about the system.

3. **Work directly with my code**
   - Quote the *exact* snippet(s) you are modifying.
   - Show changes as a **unified diff** or **before/after** blocks.
   - Keep context small but sufficient so I can copy-paste easily.

4. **Stay within the request**
   - Solve only the problem I asked about.
   - If you notice other potential issues, mention them in a short “Notes” section, but **do not** fix them unless I say so.

5. **Explain just enough**
   - After the code, give a short explanation of:
     - What changed.
     - Why it fixes the issue or achieves the behavior I asked for.
   - Keep explanations concise and practical (no long theory unless requested).

**Output Format:**
1. **Understanding**
2. **Code Changes** (diff or before/after)
3. **Explanation**
4. **Notes (Optional)**
