accessWidener v2 named

# Required to build search enabled creative tabs
accessible method net/minecraft/world/item/CreativeModeTab$Builder type (Lnet/minecraft/world/item/CreativeModeTab$Type;)Lnet/minecraft/world/item/CreativeModeTab$Builder;


<#if w.getGElementsOfType('biome')?filter(e -> e.hasVines() || e.hasFruits())?size != 0>
# Required to register custom tree decorator types
accessible method net/minecraft/world/level/levelgen/feature/treedecorators/TreeDecoratorType <init> (Lcom/mojang/serialization/MapCodec;)V
</#if>

<#if w.getGElementsOfType('biome')?filter(e -> e.spawnBiome || e.spawnInCaves || e.spawnBiomeNether)?size != 0>
# Required to add custom biome parameters to the world generation presets
accessible class net/minecraft/world/level/biome/MultiNoiseBiomeSourceParameterList$Preset$SourceProvider
</#if>

<#if w.getGElementsOfType('dimension')?filter(e -> e.enablePortal)?size != 0>
# Required by the generated portal block and portal shape
accessible field net/minecraft/world/level/portal/PortalShape numPortalBlocks I
accessible method net/minecraft/world/level/portal/PortalShape isEmpty (Lnet/minecraft/world/level/block/state/BlockState;)Z
</#if>
# Start of user code block custom AWs
# End of user code block custom AWs







accessible field net/minecraft/world/item/BucketItem content Lnet/minecraft/world/level/material/Fluid;
accessible field net/minecraft/world/level/block/LiquidBlock fluid Lnet/minecraft/world/level/material/FlowingFluid;