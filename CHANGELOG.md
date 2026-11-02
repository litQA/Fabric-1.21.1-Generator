# Changelog

## 1.0.0-beta

First beta release of the Fabric 1.21.1 generator plugin, built against MCreator 2026.3.44621 EAP.

### Generator
- Pure Fabric generator for Minecraft 1.21.1 (Fabric Loader 0.20.1, Fabric API 0.116.17, Java 25 toolchain, Gradle 9.8.0), derived from the NeoForge 1.21.1 generator with no `net.neoforged` code.
- Base templates: mod initializer, client initializer, access widener, mixin configuration and the shared trigger bus.
- Imports the datapack 1.21.1 templates, reuses the NeoForge templates for code that is loader independent.

### Elements
- Block, item, tool, armor, tab, command, GUI, overlay, particle, potion, potion effect, potion command, game rule, attribute, achievement, advancement trim, banner pattern, damage type, enchantment, function, loot table, painting, structure, dimension, biome, feature and item extension.
- Living entity and projectile entity support, including attributes, renderers and spawn eggs.
- Plant elements with growth, bonemeal, world generation, tints, render layers and plant block entities.
- Fluid elements with source and flowing fluids, liquid block, bucket item and client fluid rendering.
- Villager professions (point of interest, job site tag) and villager trades (villager and wandering trader).
- Recipes: crafting, smelting, blasting, smoking, campfire, stone cutting, smithing and brewing (potion to potion mixes).

### Procedures and variables
- Procedure block coverage against the complete NeoForge 1.21.1 baseline (562 templates). Blocks that cannot exist on Fabric emit an explicit marker and a neutral value instead of silently failing.
- Global variables (session, world and map scopes) with saved data persistence and client synchronisation; player scoped variables through a Fabric data attachment.
- Local and global variables use the standard Fabric accessors and keep working with commands and GUIs.

### Commands and tags
- Fabric command argument templates (build context argument, source level getter, Fabric fake player).
- Tags use `TagKey.create` with the vanilla registries.

### Triggers
- 62 of 65 triggers generated through Fabric events, mixins and the cancellable trigger bus.
- Cancellable events: crop growth, sapling growth, dimension travel, critical hit, block break, block place, item pickup and related triggers.
- The three remaining triggers (`entity_grief`, `block_multiplace`, `village_siege`) are explicitly unsupported and documented in `MIGRATION-REPORT.md`.

### Known limitations
- The `MIGRATION-REPORT.md` file lists every limitation: custom OBJ models, GUI item textures, dynamic fluid buckets, custom armor models, player data lifetimes, unsupported triggers and approximations for some trigger payloads.
