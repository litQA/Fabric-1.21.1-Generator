<#-- @formatter:off -->
<#include "../procedures.java.ftl">

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

import java.util.function.Supplier;

<@javacompress>
public class ${JavaModName}Items {

	<#list items as item>
	<#if item.getModElement().getTypeString() == "block" || item.getModElement().getTypeString() == "plant">
	public static final Item ${item.getModElement().getRegistryNameUpper()} = block(${JavaModName}Blocks.${item.getModElement().getRegistryNameUpper()}<#if item.hasCustomItemProperties()>, <@blockItemProperties item/></#if>);
	<#elseif item.getModElement().getTypeString() == "item">
	public static final Item ${item.getModElement().getRegistryNameUpper()} = register("${item.getModElement().getRegistryName()}", ${item.getModElement().getName()}Item::new);
	<#elseif item.getModElement().getTypeString() == "fluid">
	public static final Item ${item.getModElement().getRegistryNameUpper()}_BUCKET = register("${item.getModElement().getRegistryName()}_bucket", () -> new ${item.getModElement().getName()}Item(new Item.Properties()));
	<#elseif item.getModElement().getTypeString() == "tool">
	public static final Item ${item.getModElement().getRegistryNameUpper()} = register("${item.getModElement().getRegistryName()}", ${item.getModElement().getName()}Item::new);
	<#elseif item.getModElement().getTypeString() == "armor">
	<#if item.enableHelmet>public static final Item ${item.getModElement().getRegistryNameUpper()}_HELMET = register("${item.getModElement().getRegistryName()}_helmet", ${item.getModElement().getName()}Item.Helmet::new);</#if>
	<#if item.enableBody>public static final Item ${item.getModElement().getRegistryNameUpper()}_CHESTPLATE = register("${item.getModElement().getRegistryName()}_chestplate", ${item.getModElement().getName()}Item.Body::new);</#if>
	<#if item.enableLeggings>public static final Item ${item.getModElement().getRegistryNameUpper()}_LEGGINGS = register("${item.getModElement().getRegistryName()}_leggings", ${item.getModElement().getName()}Item.Leggings::new);</#if>
	<#if item.enableBoots>public static final Item ${item.getModElement().getRegistryNameUpper()}_BOOTS = register("${item.getModElement().getRegistryName()}_boots", ${item.getModElement().getName()}Item.Boots::new);</#if>
	<#elseif item.getModElement().getTypeString() == "dimension">
	public static final Item ${item.getModElement().getRegistryNameUpper()} = register("${item.getModElement().getRegistryName()}", ${item.getModElement().getName()}Item::new);
	<#elseif item.getModElement().getTypeString() == "livingentity">
	public static final Item ${item.getModElement().getRegistryNameUpper()}_SPAWN_EGG = register("${item.getModElement().getRegistryName()}_spawn_egg", () -> new SpawnEggItem(${JavaModName}Entities.${item.getModElement().getRegistryNameUpper()}, ${item.spawnEggBaseColor.getRGB()}, ${item.spawnEggDotColor.getRGB()}, new Item.Properties()));
	</#if>
	</#list>

	/**
	 * Forces the initialization of this class, which performs the actual item registration.
	 */
	public static void load() {
	}

	// Start of user code block custom items
	// End of user code block custom items

	private static Item register(String name, Supplier<Item> supplier) {
		return Registry.register(BuiltInRegistries.ITEM, ResourceLocation.fromNamespaceAndPath(${JavaModName}.MODID, name), supplier.get());
	}

	<#if items?filter(e -> e.getModElement().getTypeString() == "block" || e.getModElement().getTypeString() == "plant")?size != 0>
	private static Item block(Block block) {
		return block(block, new Item.Properties());
	}

	private static Item block(Block block, Item.Properties properties) {
		return register(BuiltInRegistries.BLOCK.getKey(block).getPath(), () -> new BlockItem(block, properties));
	}
	</#if>
}

<#macro blockItemProperties block>
new Item.Properties()
<#if block.maxStackSize != 64>
	.stacksTo(${block.maxStackSize})
</#if>
<#if block.rarity != "COMMON">
	.rarity(Rarity.${block.rarity})
</#if>
<#if block.immuneToFire>
	.fireResistant()
</#if>
</#macro>
</@javacompress>
<#-- @formatter:on -->




