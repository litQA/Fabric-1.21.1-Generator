<#-- @formatter:off -->
<#include "../mcitems.ftl">

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

import net.fabricmc.fabric.api.registry.FlammableBlockRegistry;
import net.fabricmc.fabric.api.registry.StrippableBlockRegistry;

import java.util.function.Supplier;

<@javacompress>
public class ${JavaModName}Blocks {

	<#list w.getGElementsOfType('dimension')?filter(e -> e.enablePortal) as dimension>
	public static final Block ${dimension.getModElement().getRegistryNameUpper()}_PORTAL =
			register("${dimension.getModElement().getRegistryName()}_portal", ${dimension.getModElement().getName()}PortalBlock::new);
	</#list>

	<#list blocks as block>
	<#if block.getModElement().getTypeString() != "dimension">
	public static final Block ${block.getModElement().getRegistryNameUpper()} =
			register("${block.getModElement().getRegistryName()}", ${block.getModElement().getName()}Block::new);
	<#if (block.getModElement().getTypeString() == "block") && block.isSign()>
	public static final Block ${block.getWallRegistryNameUpper()} =
			register("${block.getWallRegistryName()}", ${block.getWallName()}Block::new);
	</#if>
	</#if>
	</#list>

	/**
	 * Forces the initialization of this class, which performs the actual block registration, and applies
	 * the block based registry entries that have to be created after the registration itself.
	 */
	public static void load() {
		<#list blocks as block>
		<#if block.getModElement().getTypeString() != "dimension">
		<#if block.strippingResult?? && !block.strippingResult.isEmpty()>
		StrippableBlockRegistry.register(${JavaModName}Blocks.${block.getModElement().getRegistryNameUpper()}, ${mappedBlockToBlock(block.strippingResult)});
		</#if>
		<#if block.flammability != 0 && block.fireSpreadSpeed != 0>
		FlammableBlockRegistry.getDefaultInstance().add(${JavaModName}Blocks.${block.getModElement().getRegistryNameUpper()}, ${block.flammability}, ${block.fireSpreadSpeed});
		</#if>
		</#if>
		</#list>
		<#list w.getGElementsOfType('plant')?filter(e -> e.flammability != 0 && e.fireSpreadSpeed != 0) as plant>
		FlammableBlockRegistry.getDefaultInstance().add(${JavaModName}Blocks.${plant.getModElement().getRegistryNameUpper()}, ${plant.flammability}, ${plant.fireSpreadSpeed});
		</#list>
	}


	// Start of user code block custom blocks
	// End of user code block custom blocks

	private static Block register(String name, Supplier<Block> supplier) {
		return Registry.register(BuiltInRegistries.BLOCK, ResourceLocation.fromNamespaceAndPath(${JavaModName}.MODID, name), supplier.get());
	}
}
</@javacompress>
<#-- @formatter:on -->

