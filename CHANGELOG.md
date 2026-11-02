# Changelog

All notable changes to the Fabric 1.21.1 generator are documented in this file.
Entry format is descriptive and factual; entries never start with "Added" or "Fixed".

## New Content
- Project skeleton `generator-fabric-1.21.1` (plugin id `generator-fabric-1.21.1`, author LitQA, version `2026.3-1.0.0-beta`) exists for MCreator EAP 2026344621 (version codes 202600344621 - 202600399999).
- The plugin project, its configuration and its tools live in the `plugin/` folder; the repository root keeps only tooling independent content (reference resources, MCreator installation, localized caches, verification workspaces and build output).
- Static element phase started: block entities with inventories are generated through `templates/block/blockentity.java.ftl`, `templates/elementinits/blockentities.java.ftl` and `common.blockentities.yaml`; the block template implements `EntityBlock`, `newBlockEntity`, the menu provider, inventory drops, comparator output and the vibration ticker, and the mod initializer loads the block entity types.
- GUIs are generated and enabled: menu types register through `Registry.register(BuiltInRegistries.MENU, ...)` with vanilla `MenuType`, the menu keeps MCreator's `MenuAccessor` state map and syncs state through a `CustomPacketPayload` registered in `PayloadTypeRegistry`; the container is vanilla `Container` based (no item handler capability), block entities open their bound menu through `MenuProvider`/`player.openMenu`, client screens register with `MenuScreens` and the slider widget falls back to vanilla widget rendering because the sprite accessors are newer than 1.21.1.
- Dimensions are partly enabled: the dimension definition ships the data driven world generation part (`dimension_type` and `dimension` JSON for normal, nether like and end like generation) and the entry hooks for player enter and leave dimension triggers. Portal blocks, teleporters, portal shapes, igniters, custom sky boxes and client dimension effects are hidden with `field_exclusions` until the portal batch is delivered.
- HUD overlays are generated and enabled: in game overlays register through Fabric's `HudRenderCallback` and screen bound overlays attach a per screen render callback from `ScreenEvents.AFTER_INIT`/`afterRender`. The overlay class renders from a single `render(GuiGraphics)` method; the NeoForge only render priority is dropped and the overlay target is resolved by the registration filter instead of an event check.
- Villager trades are generated and enabled: trade offers register through Fabric's `TradeOfferHelper` (villager professions by level and wandering trader levels), each entry is a `VillagerTrades.ItemListing` record producing a `MerchantOffer` with price, optional second price, offer stack, max uses, xp and price multiplier.
- Recipes are generated and enabled: crafting, smelting, blasting, smoking, campfire cooking, stone cutting, smithing and the unlocking advancement use the inherited data driven JSON templates; brewing recipes register through Fabric's `FabricBrewingRecipeRegistryBuilder` (`registerPotionRecipe` for potion mixes, `registerItemRecipe` for item conversions).
- Commands are generated and enabled: each command class exposes a static `register(dispatcher, commandBuildContext, environment)` method and the command init registers every command through Fabric's `CommandRegistrationCallback`. Client side commands are registered on the integrated server dispatcher and gated by the command selection, because Fabric client commands use a different command source type; this deviation is documented.
- Potions and mob effects are generated and enabled: potions register with `Registry.register(BuiltInRegistries.POTION, ...)` and `new Potion(MobEffectInstance...)`, mob effects use `Registry.registerForHolder(BuiltInRegistries.MOB_EFFECT, ...)` so the generated holders can be used directly in potion and effect instances. The effect class keeps the vanilla hooks (instant application, active tick, mob hurt, mob removal, added sound, attribute modifiers, custom particle) and replaces the NeoForge only honey cures and effect renderer extensions with documented markers. Effect expiry procedures are emitted as documentation until the trigger phase provides a removal hook.
- Particles are generated and enabled: the particle type init registers with `Registry.register(BuiltInRegistries.PARTICLE_TYPE, ...)` using Fabric's `FabricParticleTypes.simple(...)` (the vanilla constructor is protected in 1.21.1), and the client init registers providers through `ParticleFactoryRegistry`; the particle class template uses `@Environment(EnvType.CLIENT)` instead of `@OnlyIn`.
- The attribute definition now declares the generated `AttributeSupplierAccessor` mixin itself (the NeoForge definition has no such entry because NeoForge modifies attribute maps through its own event), and the attributes init class imports that accessor explicitly instead of relying on import resolution. This fixes the `cannot find symbol: class AttributeSupplierAccessor` build failure after adding an attribute element.
- Attributes and game rules are generated and enabled: attributes register through `Registry.registerForHolder(BuiltInRegistries.ATTRIBUTE, ...)` with Fabric's `FabricDefaultAttributeRegistry` and one accessor mixin (`AttributeSupplierAccessor`, listed in the mixin configuration only when an attribute exists); game rules use Fabric's `GameRuleRegistry` and `GameRuleFactory` instead of the NeoForge setup event.- Element enablement layer fixed: the generator now ships the `*.definition.yaml` files of the supported element types (block, item, tab, procedure, living entity and the data driven achievement, armortrim, bannerpattern, damagetype, enchantment, function, loottable, painting and structure elements). MCreator builds the new element menu from the definitions physically present in the generator folder; imported definitions are not inherited and `common.*.yaml` only declares global templates.
- Living entity custom projectiles are generated through a Fabric compatible `livingentity_projectile` template (`ItemSupplier` is implemented explicitly instead of the NeoForge `@OnlyIn(_interface = ...)` interface injection).
- The living entity definition no longer references the NeoForge biome modifier JSON, the monster room data map or the NeoForge enum extension base type; natural mob spawning is scheduled for the world generation batch.
- The loot table definition no longer references the NeoForge loot modifier data files.
- Static element phase continued: living entities are generated through `templates/livingentity/livingentity.java.ftl` and the renderer template, registered with `Registry.register(BuiltInRegistries.ENTITY_TYPE, ...)` and `EntityType.Builder`; default attributes use Fabric's `FabricDefaultAttributeRegistry` and spawn placements use the vanilla `SpawnPlacements.register` API. Entity renderers are registered client side through `EntityRendererRegistry` and spawn egg items through `SpawnEggItem`.
- `common.entities.yaml` declares the entity and entity renderer init classes, so both are generated as soon as an entity exists.
- A full static element gap inventory exists at `workspace/phase1-static-element-plan.md` and `workspace/phase1-gap-inventory.csv`, listing every template of the NeoForge definition set that still needs a Fabric port, grouped by element and delivery batch.
- Generator definition `fabric-1.21.1` imports `datapack-1.21.1` and `neoforge-1.21.1` while excluding the `procedures` and `triggers` trees, so no NeoForge procedure or trigger template is inherited.
- `common.blocks.yaml`, `common.items.yaml` and `common.blockentities.yaml` ship with the generator, so the block, item and block entity init classes are generated even though the definition set is shared with the imported NeoForge generator.
- Procedure generation: `templates/procedure.java.ftl` produces Fabric procedure classes with a static `execute(...)` entry point, optional dependency null checks, local variable initialisation and the additional code blocks of the definition.
- 444 procedure block templates ship in `procedures/` covering entity, world, item, block, item stack, block state, direction, team, damage source, projectile, spawn, compare and math blocks. Flow control, arithmetic and text blocks are generated by MCreator itself and need no generator template.
- The `wait` procedure block is supported through a server tick scheduler in the mod initializer (`queueServerWork`, `ScheduledTask`, `TickTask`) driven by `ServerTickEvents.END_SERVER_TICK`.
- Fabric workspace base replaces the NeoForge workspace base completely: Fabric Loom 1.15.5, Fabric Loader 0.20.1, Fabric API 0.116.17+1.21.1, Java 21 bytecode target, local Gradle 9.8.0 distribution.
- Base mod classes implement `ModInitializer` and `ClientModInitializer`; `fabric.mod.json`, `pack.mcmeta`, mixin configuration and access widener files are generated.
- Block registration uses `Registry.register(BuiltInRegistries.BLOCK, ...)`; item registration uses `Registry.register(BuiltInRegistries.ITEM, ...)`; block items are derived from the registered block instance.
- Creative mode tabs are registered through `BuiltInRegistries.CREATIVE_MODE_TAB` with `FabricItemGroup.builder()` and populated through `ItemGroupEvents`.
- `utils/mcitems.ftl` resolves custom blocks and items to plain registry fields, removing the DeferredHolder `.get()` accessor from every generated reference.
- `utils/triggers.java.ftl` implements the vanilla 1.21.1 block hooks for the block triggers (placement, neighbour changes, entity collisions, step and fall, player destruction, projectile hits, bonemeal, client tick animation).
- Block experience drops are emitted through `spawnAfterBreak` and `popExperience`; block flammability and axe stripping through `FlammableBlockRegistry` and `StrippableBlockRegistry`.
- Block tint providers and render layers are generated into the client entrypoint with `ColorProviderRegistry` and `BlockRenderLayerMap`.
- A verification workspace (`workspace/test-1.21.1`) compiles the generated block, block entity, item, creative tab, procedure and resource set against Minecraft 1.21.1, Fabric Loader 0.20.1 and Fabric API 0.116.17.

## Changes
- Development order revised: all static elements are adapted first, then the remaining procedures and the variable/network layer, then the trigger transport and mixins.
- Procedure templates that depended on NeoForge extensions were ported to Fabric or vanilla 1.21.1 APIs: entity item operations use `Player.addItem` and `clearOrCountMatchingItems`, `is_mod_loaded` uses `FabricLoader`, the online player count uses the server player list, damage sources and configured features resolve through `registryAccess().lookupOrThrow(...)`, food values read the `DataComponents.FOOD` component, fuel power reads the Fabric `FuelRegistry`, piglin currency checks the `minecraft:piglin_loved` tag and enchantment levels read `ItemEnchantments.getLevel`.
- The wait block scheduler uses own records instead of commons-lang3 tuple classes, because Minecraft 1.21.1 depends on commons-lang3 3.14 which does not ship the `IntObjectPair` types used by the upstream template.
- The mod initializer emits its own `org.apache.logging.log4j` imports and loads sounds, blocks, block entities, items and tabs through the MCreator 2026.3 type keys.
- Templates that emit Java declare the imports of support types themselves, so generated files do not depend on the import formatter resolving every simple name.
- Client-only block features (tint providers, render layers) are emitted into the client entrypoint instead of NeoForge client extension events.
- Sound registration resolves through `BuiltInRegistries.SOUND_EVENT`.
- NeoForge only block hooks without a Fabric equivalent emit a documented marker comment instead of NeoForge imports: plant sustainability, redstone connection control, enchanting power, beacon color, fluid overlay, AI path node type, additional harvest condition.
- The NeoForge biome modifier template is removed from `block.definition.yaml`, so no `data/neoforge` resource is generated.

## Fixes
Fixed 2 bug(s).
- GUI bound blocks open their menu with the vanilla `ServerPlayer.openMenu(MenuProvider)` call; the NeoForge two argument overload that also carries the block position does not exist on 1.21.1.
- GUI bound blocks no longer emit the NeoForge ``getBoundMenuClass`` override, which produced ``method does not override or implement a method from a supertype`` after the bound block interface was replaced by Fabric menu types.

Fixed 2 bug(s).
- Block and item init classes were missing from generated workspaces: the global templates are now declared by the generator itself instead of relying on the imported definition set.
- Generated mod classes failed to compile with `cannot find symbol: class Logger`: the mod template now declares the log4j imports and the block and item loading calls use the type keys of this MCreator version.

## Known Limitations
- Static elements still inherited from NeoForge and pending their batch: projectile and special entity (boat) elements, GUI family, world generation (biomes, dimensions, features), fluids, armor, tool, particle, potion effect, command, keybind, overlay, code, dispense behaviors, fuels, brewing recipe, plant, villager professions/trades, attributes and gamerules. The complete list is in `workspace/phase1-static-element-plan.md`.
- Block entity renderers, GUI bound menus, block energy/fluid storage and block entity NBT are not generated yet; block inventories themselves are supported.
- Gamerules require access widener entries for the vanilla `GameRules` registration API before they can be generated.
- Procedure blocks for energy storage, fluid tanks, block inventories, block and entity NBT, item handler slots, GUI interaction, dimension portals and the enchanting power bonus are not shipped in this phase; procedure blocks for other element types (entities, GUI, fluids, dimensions) require their element phases.
- Procedures with an external trigger require the trigger transport, which is delivered in the trigger phase; their trigger code is not generated yet.
















## Procedure block coverage
- The procedure block set now covers the complete neoforge-1.21.1 baseline (562 templates). Previously missing blocks were added in three groups: blocks that only needed the Fabric implementation (GUI slots, text fields, checkboxes, sliders, portal creation, bucket conversions, block inventories, entity slots, submerged height, enchanting power), blocks that cannot exist on Fabric (energy, fluid tanks, custom entity and block entity data, item handler slots) which now emit an explicit marker comment and a neutral value, and event control blocks that wait for the trigger batch.
## Global variables and procedure generation
- Global variables are generated for the world and map scopes through vanilla saved data with a client sync payload; player scoped variables are documented as not generated yet.
- The procedure class template was restored from the reference generator (only the loader event import removed), so procedures with stacked blocks generate their class again.
- Global variables now generate all three documented scopes: session (memory only, per side), map (overworld saved data, shared by the save) and world (per dimension saved data). The variables class is only created when the workspace declares variables.
- Tag lookups now use ``TagKey.create`` with the vanilla registries, command argument templates were ported to Fabric (build context argument, ``getLevel()``, ``FakePlayer.get``), global variable code paths are guarded per scope, and the ``minecraft_world_loaded`` trigger is generated with a Fabric server lifecycle handler.
- Player scoped variables are generated through a Fabric data attachment with client sync, and the block break, entity death, right click block and block place trigger classes are generated (block place is a documented placeholder because Fabric has no placement event).
- Tier 1 triggers are generated with Fabric APIs: world load and unload, mod load and client and server initialisation, block break, entity death, damage allowance (attacked and pre hurt), player block, item and entity interactions, bone meal, bucket fill, chat, login, logout, respawn, player ticks, entity ticks, world ticks, entity join and spawn. Shield blocking needs a mixin and is deferred with tier 2.