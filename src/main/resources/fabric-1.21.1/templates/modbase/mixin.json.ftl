<#-- @formatter:off -->
<#assign mixins = []>
<#assign clientMixins = []>
<#if fragments?? && fragments.mixin??><#assign mixins = mixins + fragments.mixin></#if>
<#if fragments?? && fragments.client??><#assign clientMixins = clientMixins + fragments.client></#if>
<#assign clientMixins = clientMixins + ["MinecraftAttackMixin","MinecraftUseItemMixin"]>
<#if w.hasElementsOfType('attribute')><#assign mixins = mixins + ['AttributeSupplierAccessor']></#if>
<#if w.getGElementsOfType('biome')?filter(e -> e.spawnBiome || e.spawnInCaves || e.spawnBiomeNether)?size != 0><#assign mixins = mixins + ['BiomeSourcePresetMixin', 'NoiseGeneratorSettingsMixin']></#if>
<#assign mixins = mixins + ['BlockItemMixin','ResultSlotMixin','FurnaceResultSlotMixin','ItemStackMixin','LivingEntityMixin','EntityThunderMixin','TamableAnimalMixin','MobMixin','PlayerSleepMixin','ItemEntityMixin','PlayerEventsMixin','FishingHookMixin','HoeItemMixin','ExperienceOrbMixin','ExplosionMixin','FarmBlockMixin','CropGrowthMixin','SaplingGrowthMixin','EntityDimensionMixin','ServerPlayerDimensionMixin','PlayerCriticalMixin','PlayerAdvancementsMixin','CommandManagerMixin','ItemCraftingRemainderMixin']>
{
  "required": true,
  "package": "${package}.mixin",
  "compatibilityLevel": "JAVA_21",
  "mixins": [
	<#list mixins as mixin>"${mixin}"<#sep>,</#list>
  ],
  "client": [
	<#list clientMixins as mixin>"${mixin}"<#sep>,</#list>
  ],
  "injectors": {
	"defaultRequire": 0
  },
  "minVersion": "0.8.4"
}
<#-- @formatter:on -->
