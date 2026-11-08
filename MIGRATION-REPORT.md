# Migration Report - Fabric 1.21.1 Generator

## Scope Of This Report
The generator `generator-fabric-1.21.1` is produced from the definition set of the MCreator NeoForge 1.21.1
generator. Every loader-specific construct of NeoForge is replaced by a Fabric native equivalent. This report
records the architecture decisions, the corrections applied after real-device tests, the verified state and
every feature that is knowingly not available yet.

## Architecture
- Target: Minecraft 1.21.1, Fabric Loader 0.20.1, Fabric API 0.116.17, Java 21 bytecode (JDK 25 toolchain),
  Fabric Loom 1.15.5 and the locally provided Gradle 9.8.0 distribution.
- The plugin project lives in `plugin/` (a Gradle project: `build.gradle`, `settings.gradle`, `gradle.properties`). Generator sources are under `plugin/src/main/resources/fabric-1.21.1/`; `plugin.json`, `LICENSE` and `CHANGELOG.md` stay at the plugin root. `README.md` is maintained by the user. The repository root keeps only the reference resources, the local
  MCreator installation, the localized `caches/` folder, the verification workspaces, the user test workspace
  and the packaged archives in `build/`.
- The Gradle wrapper inside `workspacebase` points at the local `参考资源/gradle-9.8.0-bin.zip` archive with a
  `file:` distribution URL. The non ASCII directory name is percent encoded, because the Gradle wrapper builds a
  `java.net.URI` from the property and rejects raw non ASCII characters; the encoded URL targets the same local
  file and never performs a network download. The wrapper was verified with Gradle 9.8.0.
- The generator imports `datapack-1.21.1` (shared data driven templates such as `pack.mcmeta`, tags and loot
  tables) and `neoforge-1.21.1` with `procedures` and `triggers` excluded. Every NeoForge template that can emit
  loader specific code for the supported element set is overridden by this generator.
- Registration is performed with `Registry.register` against `BuiltInRegistries`. Blocks, items and creative
  tabs are plain static fields of the generated `init` classes and are populated when the classes are
  initialised from the mod initializer. No `DeferredRegister`, `DeferredHolder`, `DeferredBlock`,
  `DeferredItem`, `@Mod`, `@EventBusSubscriber` or `net.neoforged` type is generated.
- Loading order in the mod initializer: sounds, blocks, items, creative tabs. Tab contents are supplied through
  lambdas, so item fields are already assigned when the tab is displayed.
- Client only code (tint providers, render layers) is generated into the `ClientModInitializer` entrypoint and
  not into common classes, so a dedicated server never resolves client only classes.
- Block based registry entries that must exist after registration (flammable values, axe stripping) are applied
  in `<Mod>Blocks.load()` through `FlammableBlockRegistry` and `StrippableBlockRegistry`.

## Revised Phase Plan
The delivery order was revised after the first two phases: all static elements must be complete before the
trigger transport is implemented.

| Phase | Scope |
| --- | --- |
| Phase 1 | Every static element: blocks and items (done), block entities and inventories (batch 1 done), entities and renderers, GUI, world generation (biomes, dimensions, features), fluids, armor, tools, particles, potions, commands, key binds, overlays, villager elements, attributes, gamerules and the remaining element inits |
| Phase 2 | Remaining procedure blocks, plus the variable and network layer (`PayloadTypeRegistry`, `SavedData`/data components, player/world/map scopes with sync) |
| Phase 3 | Trigger transport: Fabric events where available, dedicated mixins with `require = 0` and lifecycle guards elsewhere, delivered in batches of 4-8 |
| Phase 4 | Packaging and documentation finalisation |

The static element inventory with every pending template is maintained in
`workspace/phase1-static-element-plan.md`; the machine readable list is `workspace/phase1-gap-inventory.csv`.

## Phase 1 - Static Elements (Batch 1: Block Entities)
- `templates/elementinits/blockentities.java.ftl` registers block entity types with
  `Registry.register(BuiltInRegistries.BLOCK_ENTITY_TYPE, ...)` and `BlockEntityType.Builder.of(...).build()`.
- `common.blockentities.yaml` declares the block entity init class as a global template, so it is generated as
  soon as a block with an inventory exists.
- `templates/block/blockentity.java.ftl` generates a `RandomizableContainerBlockEntity` with `WorldlyContainer`
  support: loot table aware load/save through `ContainerHelper` and `CompoundTag`/`HolderLookup.Provider`, update
  packet and update tag, slot restrictions from the element definition, sided automation hooks, comparator support,
  stack size, custom name, and the vibration listener when vibration sensitivity is enabled. NeoForge energy,
  fluid tank and capability code is replaced by documented marker comments.
- The block template now emits `EntityBlock`, `newBlockEntity`, `getMenuProvider`, inventory drops on removal,
  comparator output and the vibration ticker against the plain block entity fields. The NeoForge menu bound block
  interface is removed; GUI bound menus return a generic chest menu until the GUI batch is delivered.
- The mod initializer loads the block entity types through `types.base_blockentities` after the blocks.

## Phase 1 - Static Elements (Batch 2: Living Entities)
- `templates/elementinits/entities.java.ftl` registers entity types with `Registry.register(BuiltInRegistries.ENTITY_TYPE, ...)`
  and `EntityType.Builder.of(...).build(...)`, registers default attributes through Fabric's
  `FabricDefaultAttributeRegistry` and calls the entity spawn placement initialiser.
- `templates/elementinits/entityrenderers.java.ftl` is a client only init class that registers renderers through
  `EntityRendererRegistry` and falls back to `ThrownItemRenderer` for custom projectile entities.
- `templates/livingentity/livingentity.java.ftl` and `livingentity_renderer.java.ftl` are the NeoForge templates with
  every loader specific construct removed: the `DeferredHolder` accessors are replaced by plain entity type fields, the
  NeoForge `RegisterSpawnPlacementsEvent` block is replaced by the vanilla `SpawnPlacements.register(...)` calls and the
  entity type factory is used directly.
- Spawn egg items are generated in the item init class with the vanilla `SpawnEggItem(EntityType, int, int, Properties)`.
- `common.entities.yaml` declares both init classes as global templates.
- The mod initializer loads the entity types after the block entity types and before the items, and the client
  initializer registers the entity renderers.

Remaining entity work (next sub-batch): custom projectiles (`livingentity_projectile`, `projectile` and its renderer)
and special entities (boats). These still use the inherited NeoForge templates.

## Element Definition Layer (UI Enablement)
MCreator assembles the new element menu from the `*.definition.yaml` files present in the generator folder.
Imported generators contribute templates, mappings and data files, but their definitions are not merged into the
importing generator, and `common.*.yaml` files only declare global templates. The generator therefore ships the
definitions of every delivered element type:

- block, item, tab, procedure and living entity,
- the data driven definitions achievement, armortrim, bannerpattern, damagetype, enchantment, function, loottable,
  painting and structure.

NeoForge only content was removed from the shipped definitions: the living entity spawn biome modifier JSON, the
monster room entity data map, the NeoForge enum extension base type and the loot modifier data files. Natural mob
spawning and loot modifiers will be revisited with the world generation phase. Element types whose templates are
not ported yet (projectile, special entity, armor, tool, attribute, gamerule, biome, dimension, feature, fluid,
GUI, item extensions, keybind, overlay, particle, plant, potion, potion effect, command, code, villager
profession and villager trade) stay disabled until their batch is delivered.

## Phase 2 - Procedure Core
Procedure generation is delivered for the loader independent core of the procedure system:

- `templates/procedure.java.ftl` emits one class per procedure with a static `execute(...)` entry point, the
  dependency null checks, the local variable initialisation and the additional code blocks. External trigger
  code is not emitted yet; it arrives with the trigger transport in Phase 3.
- 444 block templates ship under `procedures/`, covering entity, world, item, block, item stack, block state,
  direction, team, damage source, projectile, spawn, compare and the four math helper blocks. Flow control,
  arithmetic, text and logic blocks are generated by MCreator's own blockly-to-code stage and need no
  generator template.
- The `wait` block is supported by a server tick scheduler in the mod initializer. It is implemented with own
  `ScheduledTask` and `TickTask` records instead of the upstream commons-lang3 tuple types, because Minecraft
  1.21.1 depends on commons-lang3 3.14 which does not contain `IntObjectPair`.

### Ports Applied For Phase 2
| Procedure | NeoForge construct | Fabric / vanilla 1.21.1 replacement |
| --- | --- | --- |
| `entity_add_item` | `ItemHandlerHelper.giveItemToPlayer` | `Player.addItem` |
| `entity_remove_item` | item handler capability | `Inventory.clearOrCountMatchingItems` |
| `is_mod_loaded` | `ModList.get().isLoaded` | `FabricLoader.isModLoaded` |
| `world_data_number_players_server` | `ServerLifecycleHooks.getCurrentServer` | server player list |
| `damagesource_from_type`, `..._cause`, `..._cause_directcause` | `Level.holderOrThrow` | `registryAccess().lookupOrThrow(Registries.DAMAGE_TYPE).getOrThrow` |
| `world_place_feature`, `world_place_feature_with_result` | `ServerLevel.holderOrThrow` | `registryAccess().lookupOrThrow(Registries.CONFIGURED_FEATURE).getOrThrow` |
| `item_get_food_value`, `item_get_saturation_value` | `ItemStack.getFoodProperties` | `ItemStack.get(DataComponents.FOOD)` |
| `item_fuel_power` | `ItemStack.getBurnTime` | Fabric `FuelRegistry` |
| `item_is_piglin_currency` | `ItemStack.isPiglinCurrency` | `minecraft:piglin_loved` item tag |
| `item_get_enhancement`, `itemstack_has_enchantment` | NeoForge `ItemStack.getEnchantmentLevel` | `getEnchantments().getLevel(...)` |

### Not Shipped In Phase 2
The following procedure block families require systems that are delivered later and are therefore not shipped
yet: energy storage, fluid tanks, block inventories, block and entity NBT, item handler slots, GUI interaction,
dimension portal creation, the enchanting power bonus block value and the item bucket/fluid conversions.

## Corrections Applied After The Phase 1 Real-Device Test
The first user test workspace (`用户测试/fabric1211`) reported `cannot find symbol: class Logger` and produced no
block or item init classes. Three independent root causes were identified and fixed:

1. **Global templates are not inherited.** MCreator reads the `global_templates` declarations of the generator
   that is being loaded; the declarations of the imported NeoForge generator are not used for the merged
   generator. The generator therefore now ships `common.blocks.yaml` and `common.items.yaml`, which is exactly
   what the upstream Fabric generators do.
2. **Type collection keys changed in MCreator 2026.3.** The bundled NeoForge 1.21.1 generator uses
   `types.base_blocks` and `types.base_items`, while the older Fabric template syntax `types["base:blocks"]`
   evaluates to an empty collection in this version.
3. **The Java import formatter does not resolve every simple name.** For `public static final Logger LOGGER`
   the formatter added `LogManager` but not `Logger`, which produced the reported compile error. Templates that
   emit Java now declare the imports of support types themselves.

## Verified State
- Template syntax: all shipped `.ftl` templates parse with FreeMarker 2.3.35.
- Definitions: all 5 shipped `.yaml` files load with the YAML engine MCreator uses.
- Include resolution: every `<#include>` and `<@addTemplate>` of the shipped templates resolves against the
  generator, the imported definition sets or the MCreator core resources.
- Full build: the verification workspace `workspace/test-1.21.1` produces `BUILD SUCCESSFUL` with Minecraft
  1.21.1 official Mojang mappings, Fabric Loader 0.20.1 and Fabric API 0.116.17+1.21.1. It contains a basic
  block, a tinted leaves block, an item, a creative tab and two procedures that inline the generated code of
  the entity, world, item stack, block state, damage source, feature, enchantment, fuel, math and wait blocks.
- Static audits: no `net.neoforged` construct remains in the shipped templates, and every method called by the
  shipped procedure templates exists in the vanilla 1.21.1 API surface (only Java standard library, MCreator
  `opt` helpers, `FabricLoader` and the generated `queueServerWork` helper are outside of it).
- Replay of the Phase 1 user workspace: its sources, extended with the corrected templates, compiled without
  errors against the real Fabric 1.21.1 classpath.

## Tier 2 Second Half
Additional mixins deliver the second half of tier 2: shield blocking (LivingEntity#hurt with ``isDamageSourceBlocked``), hand switching (``setItemInHand`` off hand, approximate), waking up (``stopSleepInBed``), fishing retrieval (``FishingHook#retrieve``), hoe use (``HoeItem#useOn``), item use start/stop/finish (``startUsingItem``/``stopUsingItem``/``completeUsingItem``), experience change and level change (``giveExperiencePoints``/``giveExperienceLevels``), experience drop (``dropExperience``, amounts are reported as zero because the reward is computed after the hook), experience pickup (``ExperienceOrb#playerTouch``), item pickup (``ItemEntity#playerTouch``), item drop (``Player#drop``), explosions (``Explosion#finalizeExplosion`` with a shadowed level) and farmland trampling (``FarmBlock#fallOn``).
''entity_blocks`` reports the incoming amount for both blocked amounts, ``entity_dropxp`` reports zero amounts and ``entity_switch_hand`` also fires when the off hand is set by other means; these are documented approximations.
## Command And Advancement Triggers
`command_executed` hooks `net.minecraft.commands.Commands#performCommand` and `player_completes_advancement` hooks `net.minecraft.server.PlayerAdvancements#award`; both classes are part of the client development classpath, unlike the class names guessed earlier.

## Tier 3 Triggers
The cancellable trigger infrastructure is in place: the trigger bus exposes ``eventResult``, the ``cancel event`` block sets it to false, the ``set event result`` block sets it from the configured result, and cancellable mixins read the result after the listeners run.
Generated tier 3 triggers and their approximations:
- ``crop_attempts_growth``: cancels ``CropBlock#growCrops`` when denied; forcing growth (ALLOW) is not possible, so ALLOW behaves like DEFAULT.
- ``sapling_glow``: hooks ``TreeGrower#growTree`` so it only fires when a tree feature is actually about to grow (advancing the sapling stage no longer fires it); denying stops the growth.
- ``entity_travels_to_dimension``: mixins both ``Entity#changeDimension`` and the ``ServerPlayer`` override, because players do not call the entity implementation; denying returns the current entity so the travel is skipped. The ``dimension`` dependency reports the current dimension, not the target one.
- ``player_left_click_air`` and ``player_right_click_empty_hand``: client mixins on ``Minecraft#startAttack`` and ``Minecraft#startUseItem``; they notify the procedure but cannot cancel the client action.
- ``player_critical_hit``: fires before ``Player#attack``, reports a computed vanilla critical flag and a 1.5 / 1.0 damage modifier, and denies by cancelling the attack; forcing a critical hit is not supported.
## Mixin Trigger Batch
Tier 2 mixins are generated through a shared trigger bus (``@JavaModNameTriggers`` in the ``trigger`` package) plus one mixin class per target. Implemented in this batch: ``block_place`` (BlockItem#place), ``item_crafted`` (ResultSlot#onTake), ``item_smelted`` (FurnaceResultSlot#onTake), ``item_destroyed`` (ItemStack#hurtAndBreak), ``entity_healed``, ``entity_falls``, ``entity_jumps`` and ``entity_uses_totem`` (LivingEntity), ``entity_struck_by_lightning`` (Entity#thunderHit), ``entity_tamed`` (TamableAnimal#tame), ``entity_sets_attack_target`` (Mob#setTarget), ``player_in_bed`` (Player#startSleepInBed), ``gem_expired`` (ItemEntity#tick) and ``entity_change_equipment`` which uses the Fabric entity equipment event instead of a mixin.
``command_executed`` and ``player_completes_advancement`` are generated as placeholders: their target classes (CommandManager, PlayerAdvancements) are server only and are not part of the client compile classpath used by the workspace, so a mixin cannot be compiled against them in this setup.
The mixin configuration uses ``defaultRequire: 0`` and every module is registered unconditionally, so an injection that does not match a runtime target is skipped instead of crashing the game.
## Generated Triggers
The following triggers are generated with Fabric events or initializers, without any mixin: ``minecraft_world_loaded``, ``minecraft_world_unloaded``, ``mod_load``, ``mod_clientload``, ``mod_serverload``, ``block_break``, ``entity_dies``, ``entity_attacked``, ``entity_pre_hurt``, ``player_right_click_block``, ``player_right_click_item``, ``player_right_click_entity``, ``player_left_click_block``, ``bonemeal_used``, ``bucket_filled``, ``chat_sent``, ``player_log_in``, ``player_log_out``, ``player_respawn``, ``player_ticks``, ``entity_ticks``, ``world_ticks``, ``entity_joins_world``, ``entity_spawns``.
Known semantic approximations: ``bonemeal_used`` is derived from block interaction plus the bonemealable check, ``entity_ticks`` iterates all loaded level entities once per level tick, ``entity_spawns`` uses the entity load event because spawn reasons are not exposed, and ``player_respawn`` always reports ``endconquered`` as false.
``entity_blocks`` (shield blocking) is not generated: Fabric 1.21.1 has no shield block event, so it needs a mixin and is handled with the next trigger batch.
## Player Variables
Player scoped variables (``PLAYER_LIFETIME`` and ``PLAYER_PERSISTENT``) are stored in a per player Fabric data attachment (``AttachmentRegistry.createPersistent`` with ``CompoundTag.CODEC``) and cached per UUID, with a client copy kept through the ``SavedDataSyncMessage`` payload. Both scopes currently persist across death: the reference generator copies only ``PLAYER_PERSISTENT`` values on respawn while lifetime values are reset, and that split is not implemented yet.
## Commands, Tags And Triggers
- Command argument templates (``cmdargs/``) are shipped in a Fabric flavour: ``commandBuildContext`` is passed as a method argument, ``CommandSourceStack#getLevel()`` replaces the loader specific unsided level getter and the Fabric ``FakePlayer.get(ServerLevel)`` replaces the loader fake player factory.
- Tag lookups use ``TagKey.create(Registries.BLOCK/ITEM/... , ResourceLocation)``; the loader specific ``BlockTags.create(ResourceLocation)`` and ``ItemTags.create(ResourceLocation)`` helpers no longer exist in 1.21.1.
- Only the ``minecraft_world_loaded`` trigger is generated so far (``ServerLifecycleEvents.SERVER_STARTED``). The remaining triggers need dedicated Fabric event or mixin implementations and are listed here as not generated yet: ``block_break``, ``block_place``, ``entity_dies``, ``player_right_click_block`` and every other reference trigger. Procedures with these triggers are not generated and will not compile if referenced.
## Global Variables
The variable types shipped in the ``variables/`` directory define the workspace variable editor (number, string, logic, entity, item stack, block state, vector, direction, damage source, action result type). The player scopes (``player_lifetime`` and ``player_persistent``) are removed from these definitions because the reference implementation reads them through the loader player data attachment; only ``local``, ``global_session``, ``global_world`` and ``global_map`` scopes are offered.
Global variables are generated through ``modbase/variableslist.java.ftl`` as a base template into ``network/@JavaModNameVariables.java`` (only generated when the workspace declares at least one variable):
- ``GLOBAL_SESSION``: plain static fields kept in memory on each side, never persisted and never synchronised.
- ``GLOBAL_MAP``: stored in the overworld ``SavedData`` so the whole save shares one instance; synchronised with ``SavedDataSyncMessage``.
- ``GLOBAL_WORLD``: stored in the ``SavedData`` of the current dimension, so every dimension has its own copy; synchronised with ``SavedDataSyncMessage``.
- ``PLAYER_LIFETIME`` and ``PLAYER_PERSISTENT`` scopes are not generated: the player data attachment and its accessors used by the reference generator are loader specific and the Fabric attachment API would need a matching rewrite of every player variable access block in the MCreator core. Workspaces that use player scoped variables will not compile until this is delivered.
## Procedure Block Limitations
The procedure block set is complete against the neoforge-1.21.1 baseline; every template exists and no template is silently skipped. Templates that cannot be implemented on Fabric 1.21.1 emit an explicit English marker comment and a neutral value (``PROCEDURE-COVERAGE.md`` lists each one):
- Energy blocks (energy stored, capacity, insert/extract and their checks) use the loader capability API; no Fabric equivalent exists.
- Fluid tank blocks (amount, capacity, fill/drain and their checks) use the loader capability API.
- Block and entity NBT get/set blocks use the loader persistent data API; Fabric entities and block entities have no equivalent custom data slot.
- Event control blocks (cancel event, set event result, set event parameter) depend on the NeoForge event bus; they are stubbed until the trigger batch.
- Item handler slot blocks and item based inventories need the loader item handler API; item inventories are kept in memory only and do not persist.
- Custom Java item renderers are not emitted; the generated class only states the limitation.
## Unsupported Triggers
The following triggers are intentionally not generated and are marked as unsupported for this release. Their procedure classes are not created, so procedures using these triggers will not compile: ``entity_grief`` (no generic mob griefing hook on Fabric, would require per entity mixins), ``block_multiplace`` (multi block placement event has no Fabric equivalent and conflicts with the block place trigger) and ``village_siege`` (the village siege AI state machine has no stable injection point and no Fabric event).
## Known Limitations
- Tool crafting remainder behaviour (stay in grid when crafting and damage on crafting) is not generated: 1.21.1 makes the crafting remainder component based and `Item#getCraftingRemainingItem()` final.
- Custom OBJ models (``json/item_cmodel_obj`` and ``json/block_cmodel_obj``) are not rendered: the NeoForge OBJ loaders do not exist on Fabric 1.21.1, so these model templates produce no usable geometry.
- Separate GUI textures (the per item "GUI texture" field) are not supported: they rely on the NeoForge ``separate_transforms`` model loader. Fabric generates a single texture for all display contexts.
- Fluid buckets do not render the contained fluid dynamically: without an explicit bucket texture the generated model falls back to the vanilla bucket icon, because Fabric has no equivalent of the NeoForge ``fluid_container`` model loader.
- Custom armor models, glow layers, translucency and piglin neutral behaviour are not generated; armor always uses the vanilla humanoid model and the ``_layer_1`` / ``_layer_2`` armor textures.
- Brewing recipes only support potion to potion mixes. 1.21.1 brewing is content based (``Holder<Potion>`` input plus an ingredient) and the builder rejects item inputs; brewing recipes that mix arbitrary items are emitted as a comment marker instead of being registered, because the vanilla brewing builder throws when a non potion item is used as the input.
- Special entities (boats) are not generated: 1.21.1 fabric has no way to extend the ``Boat$Type`` enum (NeoForge uses its enum extension system), and a custom boat needs a matching enum type, a ``BoatItem`` variant and a boat renderer. Custom boat variants therefore cannot be delivered with the vanilla boat entity.
- Shield tools (``toolType %= Shield``) block damage correctly, but the blocking pose is not the vanilla shield pose: the item is rendered as a regular 2D handheld item and the client plays the generic item use animation instead of the shield blocking animation. Vanilla shields use a ``builtin/entity`` model rendered by a special item renderer and a shield specific UV texture layout; reproducing that for arbitrary item textures requires a dedicated shield texture layout plus a client special renderer, which is not delivered. (Phase 1 + Phase 2)
### Not Generated Yet
- Trigger transport (Phase 3): procedures with an external trigger cannot be generated yet, and the procedure
  trigger event result helpers (`_cancel_event`, `_set_event_result`, `_event_parameter_set`) are not shipped.
- Block entity renderers, GUI bound menus, block energy/fluid storage and block entity NBT are not shipped yet;
  block inventories themselves are supported. Item inventories (NeoForge item handler capability) have no vanilla
  counterpart and need a dedicated custom inventory implementation.
- Gamerules need access widener entries for the vanilla `GameRules` registration API before they can be generated.
- Energy, fluid tanks, block/entity NBT (data components), item handler slots, GUI interaction, dimension
  portals and the enchanting power bonus remain available only in later phases.
- Entities, projectile entities, GUIs, menus, fluids, dimensions, biomes, features, armor, tools, potions,
  enchantments, villager professions, overlays, particles, key bindings, paintings and loot modifiers keep their
  inherited NeoForge templates and are intentionally not part of the delivered phases.
- World generation for blocks (`generateFeature`) still emits the configured and placed feature JSON only, so
  generated ore features are not placed in the world yet.
- Custom Java item models, custom item properties and search tab appearance remain unverified or unsupported.
- Block bases other than the plain block are checked against the 1.21.1 constructor signatures but are not part
  of the compiled verification workspace: stairs, slab, fence, wall, door, trapdoor, button, pressure plate,
  fence gate, pane, end rod and leaves.

### NeoForge Features Without A Direct Fabric Equivalent
- `canSustainPlant` (`plantsGrowOn`), `canConnectRedstone`, `getEnchantPowerBonus`, `getBeaconColorMultiplier`,
  `shouldDisplayFluidOverlay`, `getBlockPathType` and `canHarvestBlock` are NeoForge block patches without a
  vanilla or Fabric counterpart; the generator emits documented marker comments instead.
- Flower pot content registration has no public API in 1.21.1, so the empty pot does not convert to a potted
  custom block yet.
- Stack aware crafting remainders (`damageOnCrafting`) are not available; only the static recipe remainder is
  generated.
- Loot modifiers, data maps, biome modifiers, `BlockEntityTypeAddBlocksEvent` and attribute/capability based item
  inventories are NeoForge data or event systems without a counterpart in this phase.

## Real Device Test Checklist (Phase 2)
1. Install `build/generator-fabric-1.21.1.zip`, open the test workspace and regenerate the code.
2. Create a procedure that uses flow control (if/else, repeat or while), an arithmetic block, a text block, an
   entity block (set health or add item) and the wait block. Call it from a block right click.
3. Run the client: the procedure must execute when the block is right clicked, the entity change must be
   visible, and the wait block must execute its body after the configured delay.





