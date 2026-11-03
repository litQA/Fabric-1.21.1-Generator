# Changelog

Versioning: the patch component of the version is incremented by one for every change unless stated otherwise.

## 1.0.1-beta

### Fixes
- Opening a GUI from a procedure, an item or a living entity now uses the vanilla single argument `openMenu(MenuProvider)` call. The loader specific two argument variant and the extra screen closing method were removed, because they failed to compile on Fabric.
- GUI tick procedures now run from the server tick event and iterate the online players instead of using a loader specific player tick event.
- A zero usage count on a tool no longer generates a loader specific component modification; the item is already created without a durability component and is therefore unbreakable.

## 1.0.0-beta

### New Content

#### Generator
- Pure Fabric generator for Minecraft 1.21.1 with Fabric Loader and Fabric API, built for the Java toolchain of the target MCreator release.
- Base templates: mod initializer, client initializer, access widener, mixin configuration and a shared trigger bus.
- Inherits the datapack templates and reuses the loader independent templates of the NeoForge generator.

#### Elements
- Block, item, tool, armor, tab, command, GUI, overlay, particle, potion, potion effect, game rule, attribute, achievement, advancement trim, banner pattern, damage type, enchantment, function, loot table, painting, structure, dimension, biome, feature and item extension.
- Living entity and projectile entity support including attributes, renderers and spawn eggs.
- Plant elements with growth, bonemeal, world generation, tints, render layers and plant block entities.
- Fluid elements with source and flowing fluids, liquid block, bucket item and client fluid rendering.
- Villager professions (point of interest and job site tag) and villager trades for villagers and the wandering trader.
- Recipes: crafting, smelting, blasting, smoking, campfire cooking, stone cutting, smithing and brewing (potion to potion mixes).

#### Procedures and Variables
- Procedure block coverage against the complete NeoForge 1.21.1 baseline. Blocks that cannot exist on Fabric emit an explicit marker and a neutral value instead of silently failing.
- Global variables (session, world and map scopes) with saved data persistence and client synchronisation.
- Player scoped variables through a Fabric data attachment.

#### Commands and Tags
- Fabric command argument templates using the build context argument, the source level getter and the Fabric fake player.
- Tags use `TagKey.create` with the vanilla registries.

#### Triggers
- 62 of 65 triggers generated through Fabric events, mixins and the cancellable trigger bus.
- Cancellable events: crop growth, sapling growth, dimension travel, critical hit, block break, block place, item pickup and related triggers.
- The remaining three triggers (`entity_grief`, `block_multiplace`, `village_siege`) are explicitly unsupported and documented in `MIGRATION-REPORT.md`.

### Changes
- All NeoForge specific code was replaced with Fabric equivalents; the migration report lists architecture decisions, verified behaviour and known limitations.

### Fixes
- Initial release, no fixes yet.
