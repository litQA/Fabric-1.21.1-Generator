<#-- @formatter:off -->
package ${package};

import net.fabricmc.api.ClientModInitializer;
import net.fabricmc.api.EnvType;
import net.fabricmc.api.Environment;
import net.fabricmc.fabric.api.blockrenderlayer.v1.BlockRenderLayerMap;
import net.fabricmc.fabric.api.client.rendering.v1.ColorProviderRegistry;

import net.minecraft.client.renderer.BiomeColors;
import net.minecraft.client.renderer.RenderType;
import net.minecraft.world.level.FoliageColor;
import net.minecraft.world.level.GrassColor;

@Environment(EnvType.CLIENT) public class ${JavaModName}Client implements ClientModInitializer {

	@Override public void onInitializeClient() {
		// Start of user code block mod constructor
		// End of user code block mod constructor

		<@javacompress>
		<#if w.getGElementsOfType('block')?filter(e -> e.transparencyType != "SOLID")?size != 0>
		<#list w.getGElementsOfType('block') as block>
		<#if block.transparencyType != "SOLID">
		BlockRenderLayerMap.INSTANCE.putBlock(${JavaModName}Blocks.${block.getModElement().getRegistryNameUpper()}, <#if block.transparencyType == "CUTOUT_MIPPED">RenderType.cutoutMipped()<#elseif block.transparencyType == "TRANSLUCENT">RenderType.translucent()<#else>RenderType.cutout()</#if>);
		</#if>
		</#list>
		</#if>

		<#if w.getGElementsOfType('block')?filter(e -> e.tintType != "No tint")?size != 0>
		<#list w.getGElementsOfType('block') as block>
		<#if block.tintType != "No tint">
		ColorProviderRegistry.BLOCK.register((state, world, pos, tintIndex) -> {
			<#if block.tintType == "Default foliage">
			return FoliageColor.getDefaultColor();
			<#elseif block.tintType == "Birch foliage">
			return FoliageColor.getBirchColor();
			<#elseif block.tintType == "Spruce foliage">
			return FoliageColor.getEvergreenColor();
			<#elseif block.tintType == "Dry foliage">
			return 10710342;
			<#elseif block.tintType == "Grass">
			return world != null && pos != null ? BiomeColors.getAverageGrassColor(world, pos) : GrassColor.get(0.5D, 1.0D);
			<#elseif block.tintType == "Foliage">
			return world != null && pos != null ? BiomeColors.getAverageFoliageColor(world, pos) : FoliageColor.getDefaultColor();
			<#elseif block.tintType == "Water">
			return world != null && pos != null ? BiomeColors.getAverageWaterColor(world, pos) : -1;
			<#elseif block.tintType == "Sky">
			return world != null && pos != null ? world.getBiome(pos).value().getSkyColor() : 8562943;
			<#elseif block.tintType == "Fog">
			return world != null && pos != null ? world.getBiome(pos).value().getFogColor() : 12638463;
			<#else>
			return world != null && pos != null ? world.getBiome(pos).value().getWaterFogColor() : 329011;
			</#if>
		}, ${JavaModName}Blocks.${block.getModElement().getRegistryNameUpper()});
		<#if block.isItemTinted && block.hasBlockItem>
		ColorProviderRegistry.ITEM.register((stack, tintIndex) -> {
			<#if block.tintType == "Grass">
			return GrassColor.get(0.5D, 1.0D);
			<#elseif block.tintType == "Foliage" || block.tintType == "Default foliage">
			return FoliageColor.getDefaultColor();
			<#elseif block.tintType == "Birch foliage">
			return FoliageColor.getBirchColor();
			<#elseif block.tintType == "Spruce foliage">
			return FoliageColor.getEvergreenColor();
			<#elseif block.tintType == "Dry foliage">
			return 10710342;
			<#elseif block.tintType == "Water">
			return 3694022;
			<#elseif block.tintType == "Sky">
			return 8562943;
			<#elseif block.tintType == "Fog">
			return 12638463;
			<#else>
			return 329011;
			</#if>
		}, ${JavaModName}Items.${block.getModElement().getRegistryNameUpper()});
		</#if>
		</#if>
		</#list>
		</#if>

		<#if types.base_entities?has_content>${JavaModName}EntityRenderers.clientLoad();</#if>
		<#if w.getGElementsOfType('fluid')?size != 0>${JavaModName}Fluids.clientLoad();</#if>
		<#if w.hasVariables()>${JavaModName}Variables.loadClient();</#if>
		<#if w.hasElementsOfType('particle')>${JavaModName}Particles.clientLoad();</#if>
		<#if w.hasElementsOfType('overlay')>${JavaModName}Overlays.clientLoad();</#if>
		<#list w.getGElementsOfType('plant') as plant>
		${plant.getModElement().getName()}Block.registerRenderLayer();
		</#list>

		<#-- Plant tint providers are registered from the plant template helpers -->
		<#list w.getGElementsOfType('plant')?filter(e -> e.tintType != "No tint") as plant>
		${plant.getModElement().getName()}Block.blockColorLoad();
		<#if plant.isItemTinted && plant.hasBlockItem>
		${plant.getModElement().getName()}Block.itemColorLoad();
		</#if>
		</#list>
		<#if w.hasElementsOfType('gui')>${JavaModName}Screens.clientLoad();</#if>

		</@javacompress>

		// Start of user code block mod init
		// End of user code block mod init
	}

	// Start of user code block mod methods
	// End of user code block mod methods
}
<#-- @formatter:on -->








