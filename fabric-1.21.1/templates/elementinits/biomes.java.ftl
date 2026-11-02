<#-- @formatter:off -->
<#include "../mcitems.ftl">

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

import com.mojang.datafixers.util.Pair;
<#assign spawn_overworld = biomes?filter(biome -> biome.spawnBiome)>
<#assign spawn_overworld_caves = biomes?filter(biome -> biome.spawnInCaves)>
<#assign spawn_nether = biomes?filter(biome -> biome.spawnBiomeNether)>
<#assign decoratedBiomes = biomes?filter(e -> e.hasVines() || e.hasFruits())>
<#assign spawnableBiomes = biomes?filter(e -> e.spawnBiome || e.spawnInCaves || e.spawnBiomeNether)>

public class ${JavaModName}Biomes {

	public static final ResourceLocation OVERWORLD_BIOMESOURCE_PRESET_ID = ResourceLocation.withDefaultNamespace("overworld");
	public static final ResourceLocation NETHER_BIOMESOURCE_PRESET_ID = ResourceLocation.withDefaultNamespace("nether");

	<#if decoratedBiomes?has_content>
	public static void load() {
		<#list decoratedBiomes as biome>
			<#assign biomeME = biome.getModElement()>
			<#if biome.hasFruits()>
		register("${biomeME.getRegistryName()}_tree_fruit_decorator", ${biomeME.getName()}FruitDecorator.DECORATOR_TYPE);
			</#if>
			<#if biome.hasVines()>
		register("${biomeME.getRegistryName()}_tree_leave_decorator", ${biomeME.getName()}LeaveDecorator.DECORATOR_TYPE);
		register("${biomeME.getRegistryName()}_tree_trunk_decorator", ${biomeME.getName()}TrunkDecorator.DECORATOR_TYPE);
			</#if>
		</#list>
	}

	private static void register(String registryname, TreeDecoratorType<?> treeDecoratorType) {
		Registry.register(BuiltInRegistries.TREE_DECORATOR_TYPE, ResourceLocation.fromNamespaceAndPath(${JavaModName}.MODID, registryname), treeDecoratorType);
	}
	</#if>

	<#if spawnableBiomes?has_content>
	public static void init() {
		ServerLifecycleEvents.SERVER_STARTING.register(server -> {
			for (LevelStem levelStem : server.registryAccess().registryOrThrow(Registries.LEVEL_STEM).stream().toList()) {
				Holder<DimensionType> dimensionType = levelStem.type();
				if (dimensionType.is(BuiltinDimensionTypes.NETHER) || dimensionType.is(BuiltinDimensionTypes.OVERWORLD)) {
					if (levelStem.generator() instanceof NoiseBasedChunkGenerator noiseGenerator
							&& (Object) noiseGenerator.generatorSettings().value() instanceof ${JavaModName}NoiseGeneratorSettings settings) {
						settings.set${modid}DimensionTypeReference(dimensionType);
					}
				}
			}
		});
	}

	public static <T> Climate.ParameterList<T> adaptPresetParameterList(ResourceLocation idArg, Climate.ParameterList<T> originalList, Function<ResourceKey<Biome>, T> lookup) {
		try {
			<#if spawn_overworld?has_content || spawn_overworld_caves?has_content>
			if (idArg.equals(OVERWORLD_BIOMESOURCE_PRESET_ID)) return modifyOverworldParameterPoints(originalList, lookup);
			</#if>
			<#if spawn_nether?has_content>
			if (idArg.equals(NETHER_BIOMESOURCE_PRESET_ID)) return modifyNetherParameterPoints(originalList, lookup);
			</#if>
		} catch (RuntimeException exception) {
			<#-- During the registry bootstrap validation the custom biomes are not available yet -->
			${JavaModName}.LOGGER.debug("Skipping custom biome adaptation for preset {}: {}", idArg, exception.getMessage());
		}
		return originalList;
	}
	</#if>

	<#if spawnableBiomes?has_content && (spawn_overworld?has_content || spawn_overworld_caves?has_content)>
	public static <T> Climate.ParameterList<T> modifyOverworldParameterPoints(Climate.ParameterList<T> originalList, Function<ResourceKey<Biome>, T> lookup) {
		List<Pair<Climate.ParameterPoint, T>> parameters = new ArrayList<>(originalList.values());

		<#list spawn_overworld as biome>
		T ${biome.getModElement().getRegistryName()?replace("-", "_")}Biome = lookup.apply(ResourceKey.create(Registries.BIOME, ResourceLocation.fromNamespaceAndPath("${modid}", "${biome.getModElement().getRegistryName()}")));
		parameters.add(surfaceParameterPoint(${biome.genTemperature.min}f, ${biome.genTemperature.max}f, ${biome.genHumidity.min}f, ${biome.genHumidity.max}f,
				${biome.genContinentalness.min}f, ${biome.genContinentalness.max}f, ${biome.genErosion.min}f, ${biome.genErosion.max}f,
				${biome.genWeirdness.min}f, ${biome.genWeirdness.max}f, 0.0f, ${biome.getModElement().getRegistryName()?replace("-", "_")}Biome));
		parameters.add(surfaceParameterPoint(${biome.genTemperature.min}f, ${biome.genTemperature.max}f, ${biome.genHumidity.min}f, ${biome.genHumidity.max}f,
				${biome.genContinentalness.min}f, ${biome.genContinentalness.max}f, ${biome.genErosion.min}f, ${biome.genErosion.max}f,
				${biome.genWeirdness.min}f, ${biome.genWeirdness.max}f, 1.0f, ${biome.getModElement().getRegistryName()?replace("-", "_")}Biome));
		</#list>

		<#list spawn_overworld_caves as biome>
		parameters.add(caveParameterPoint(${biome.genTemperature.min}f, ${biome.genTemperature.max}f, ${biome.genHumidity.min}f, ${biome.genHumidity.max}f,
				${biome.genContinentalness.min}f, ${biome.genContinentalness.max}f, ${biome.genErosion.min}f, ${biome.genErosion.max}f,
				${biome.genDepth.min}f, ${biome.genDepth.max}f, ${biome.genWeirdness.min}f, ${biome.genWeirdness.max}f,
				lookup.apply(ResourceKey.create(Registries.BIOME, ResourceLocation.fromNamespaceAndPath("${modid}", "${biome.getModElement().getRegistryName()}")))));
		</#list>

		return new Climate.ParameterList<>(parameters);
	}
	</#if>

	<#if spawnableBiomes?has_content && spawn_nether?has_content>
	public static <T> Climate.ParameterList<T> modifyNetherParameterPoints(Climate.ParameterList<T> originalList, Function<ResourceKey<Biome>, T> lookup) {
		List<Pair<Climate.ParameterPoint, T>> parameters = new ArrayList<>(originalList.values());

		<#list spawn_nether as biome>
		T ${biome.getModElement().getRegistryName()?replace("-", "_")}Biome = lookup.apply(ResourceKey.create(Registries.BIOME, ResourceLocation.fromNamespaceAndPath("${modid}", "${biome.getModElement().getRegistryName()}")));
		parameters.add(surfaceParameterPoint(${biome.genTemperature.min}f, ${biome.genTemperature.max}f, ${biome.genHumidity.min}f, ${biome.genHumidity.max}f,
				${biome.genContinentalness.min}f, ${biome.genContinentalness.max}f, ${biome.genErosion.min}f, ${biome.genErosion.max}f,
				${biome.genWeirdness.min}f, ${biome.genWeirdness.max}f, 0.0f, ${biome.getModElement().getRegistryName()?replace("-", "_")}Biome));
		parameters.add(surfaceParameterPoint(${biome.genTemperature.min}f, ${biome.genTemperature.max}f, ${biome.genHumidity.min}f, ${biome.genHumidity.max}f,
				${biome.genContinentalness.min}f, ${biome.genContinentalness.max}f, ${biome.genErosion.min}f, ${biome.genErosion.max}f,
				${biome.genWeirdness.min}f, ${biome.genWeirdness.max}f, 1.0f, ${biome.getModElement().getRegistryName()?replace("-", "_")}Biome));
		</#list>

		return new Climate.ParameterList<>(parameters);
	}
	</#if>

	<#if spawnableBiomes?has_content>
	/**
	 * Surface parameter point: depth is a single point (0 = preliminary surface, 1 = above surface), which is what vanilla
	 * uses for surface biomes. Using a depth span here makes the biome generate as an underground biome.
	 */
	public static <T> Pair<Climate.ParameterPoint, T> surfaceParameterPoint(float tempMin, float tempMax, float humidityMin, float humidityMax,
			float continentalnessMin, float continentalnessMax, float erosionMin, float erosionMax, float weirdnessMin, float weirdnessMax,
			float depth, T value) {
		return new Pair<>(new Climate.ParameterPoint(
				Climate.Parameter.span(tempMin, tempMax),
				Climate.Parameter.span(humidityMin, humidityMax),
				Climate.Parameter.span(continentalnessMin, continentalnessMax),
				Climate.Parameter.span(erosionMin, erosionMax),
				Climate.Parameter.point(depth),
				Climate.Parameter.span(weirdnessMin, weirdnessMax),
				0), value);
	}

	public static <T> Pair<Climate.ParameterPoint, T> caveParameterPoint(float tempMin, float tempMax, float humidityMin, float humidityMax,
			float continentalnessMin, float continentalnessMax, float erosionMin, float erosionMax, float depthMin, float depthMax,
			float weirdnessMin, float weirdnessMax, T value) {
		return new Pair<>(new Climate.ParameterPoint(
				Climate.Parameter.span(tempMin, tempMax),
				Climate.Parameter.span(humidityMin, humidityMax),
				Climate.Parameter.span(continentalnessMin, continentalnessMax),
				Climate.Parameter.span(erosionMin, erosionMax),
				Climate.Parameter.span(depthMin, depthMax),
				Climate.Parameter.span(weirdnessMin, weirdnessMax),
				0), value);
	}
	</#if>
	<#if spawnableBiomes?has_content>
	/**
	 * Returns the custom surface rules of this mod, or null when the dimension has no custom surface rules.
	 * The rules only use public vanilla API, so no additional access widener entries are required.
	 */
	public static SurfaceRules.RuleSource customSurfaceRules(Holder<DimensionType> dimensionType) {
		List<SurfaceRules.RuleSource> customSurfaceRules = new ArrayList<>();
		<#if spawn_overworld?has_content || spawn_overworld_caves?has_content>
		if (dimensionType.is(BuiltinDimensionTypes.OVERWORLD)) {
			<#list spawn_overworld_caves as biome>
			customSurfaceRules.add(anySurfaceRule(ResourceKey.create(Registries.BIOME, ResourceLocation.fromNamespaceAndPath("${modid}", "${biome.getModElement().getRegistryName()}")),
					${mappedBlockToBlockStateCode(biome.groundBlock)}, ${mappedBlockToBlockStateCode(biome.undergroundBlock)}, ${mappedBlockToBlockStateCode(biome.getUnderwaterBlock())}));
			</#list>
			<#list spawn_overworld as biome>
			customSurfaceRules.add(preliminarySurfaceRule(ResourceKey.create(Registries.BIOME, ResourceLocation.fromNamespaceAndPath("${modid}", "${biome.getModElement().getRegistryName()}")),
					${mappedBlockToBlockStateCode(biome.groundBlock)}, ${mappedBlockToBlockStateCode(biome.undergroundBlock)}, ${mappedBlockToBlockStateCode(biome.getUnderwaterBlock())}));
			</#list>
		}
		</#if>
		<#if spawn_nether?has_content>
		if (dimensionType.is(BuiltinDimensionTypes.NETHER)) {
			<#list spawn_nether as biome>
			customSurfaceRules.add(anySurfaceRule(ResourceKey.create(Registries.BIOME, ResourceLocation.fromNamespaceAndPath("${modid}", "${biome.getModElement().getRegistryName()}")),
					${mappedBlockToBlockStateCode(biome.groundBlock)}, ${mappedBlockToBlockStateCode(biome.undergroundBlock)}, ${mappedBlockToBlockStateCode(biome.getUnderwaterBlock())}));
			</#list>
		}
		</#if>

		if (customSurfaceRules.isEmpty()) return null;
		return SurfaceRules.sequence(customSurfaceRules.toArray(SurfaceRules.RuleSource[]::new));
	}


	private static SurfaceRules.RuleSource preliminarySurfaceRule(ResourceKey<Biome> biomeKey, BlockState groundBlock, BlockState undergroundBlock, BlockState underwaterBlock) {
		return SurfaceRules.ifTrue(SurfaceRules.isBiome(biomeKey),
			SurfaceRules.ifTrue(SurfaceRules.abovePreliminarySurface(),
				SurfaceRules.sequence(
					SurfaceRules.ifTrue(SurfaceRules.stoneDepthCheck(0, false, 0, CaveSurface.FLOOR),
						SurfaceRules.sequence(
							SurfaceRules.ifTrue(SurfaceRules.waterBlockCheck(-1, 0), SurfaceRules.state(groundBlock)),
							SurfaceRules.state(underwaterBlock)
						)
					),
					SurfaceRules.ifTrue(SurfaceRules.stoneDepthCheck(0, true, 0, CaveSurface.FLOOR), SurfaceRules.state(undergroundBlock))
				)
			)
		);
	}

	private static SurfaceRules.RuleSource anySurfaceRule(ResourceKey<Biome> biomeKey, BlockState groundBlock, BlockState undergroundBlock, BlockState underwaterBlock) {
		return SurfaceRules.ifTrue(SurfaceRules.isBiome(biomeKey),
			SurfaceRules.ifTrue(SurfaceRules.yBlockCheck(VerticalAnchor.aboveBottom(5), 0),
				SurfaceRules.ifTrue(SurfaceRules.not(SurfaceRules.yBlockCheck(VerticalAnchor.belowTop(5), 0)),
					SurfaceRules.sequence(
						SurfaceRules.ifTrue(SurfaceRules.stoneDepthCheck(0, false, 0, CaveSurface.FLOOR),
							SurfaceRules.sequence(
								SurfaceRules.ifTrue(SurfaceRules.waterBlockCheck(-1, 0), SurfaceRules.state(groundBlock)),
								SurfaceRules.state(underwaterBlock)
							)
						),
						SurfaceRules.ifTrue(SurfaceRules.stoneDepthCheck(0, true, 0, CaveSurface.FLOOR), SurfaceRules.state(undergroundBlock))
					)
				)
			)
		);
	}

	public interface ${JavaModName}NoiseGeneratorSettings {
		void set${modid}DimensionTypeReference(Holder<DimensionType> dimensionType);
	}
	</#if>
}
<#-- @formatter:on -->




