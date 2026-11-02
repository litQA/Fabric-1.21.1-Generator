<#-- @formatter:off -->
<#include "../mcitems.ftl">

<#assign tabMap = w.getCreativeTabMap()>
<#assign vanillaTabs = tabMap.keySet()?filter(e -> !e?starts_with('CUSTOM:'))>
<#assign customTabs = tabMap.keySet()?filter(e -> e?starts_with('CUSTOM:'))>

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

import net.fabricmc.fabric.api.itemgroup.v1.FabricItemGroup;
import net.fabricmc.fabric.api.itemgroup.v1.ItemGroupEvents;

<@javacompress>
public class ${JavaModName}Tabs {

	<#list customTabs as customTab>
	<#assign tab = w.getWorkspace().getModElementByName(customTab.replace("CUSTOM:", "")).getGeneratableElement()>
	public static final ResourceKey<CreativeModeTab> TAB_${tab.getModElement().getRegistryNameUpper()} =
			ResourceKey.create(Registries.CREATIVE_MODE_TAB, ResourceLocation.fromNamespaceAndPath(${JavaModName}.MODID, "${tab.getModElement().getRegistryName()}"));
	</#list>

	public static void load() {
		<#list customTabs as customTab>
		<#assign tab = w.getWorkspace().getModElementByName(customTab.replace("CUSTOM:", "")).getGeneratableElement()>
		Registry.register(BuiltInRegistries.CREATIVE_MODE_TAB, TAB_${tab.getModElement().getRegistryNameUpper()}, FabricItemGroup.builder()
			.title(Component.translatable("item_group.${modid}.${tab.getModElement().getRegistryName()}"))
			.icon(() -> ${mappedMCItemToItemStackCode(tab.icon, 1)})
			<#if tab.showSearch>
			.type(CreativeModeTab.Type.SEARCH)
			.backgroundTexture(ResourceLocation.withDefaultNamespace("textures/gui/container/creative_inventory/tab_item_search.png"))
			</#if>
			<#if tab.hideTitle>
			.hideTitle()
			</#if>
			.displayItems((parameters, tabData) -> {
				<#list tabMap.get("CUSTOM:" + tab.getModElement().getName()) as tabElement>
				tabData.accept(${mappedMCItemToItem(tabElement)});
				</#list>
			}).build()
		);
		</#list>

		<#if vanillaTabs?has_content>
		<#list vanillaTabs as tabName>
		ItemGroupEvents.modifyEntriesEvent(${generator.map(tabName, "tabs")}).register(tabData -> {
			<#list tabMap.get(tabName) as tabElement>
			tabData.accept(${mappedMCItemToItem(tabElement)}<#if tabName == "OP_BLOCKS">, CreativeModeTab.TabVisibility.PARENT_TAB_ONLY</#if>);
			</#list>
		});
		</#list>
		</#if>
	}
}
</@javacompress>
<#-- @formatter:on -->
