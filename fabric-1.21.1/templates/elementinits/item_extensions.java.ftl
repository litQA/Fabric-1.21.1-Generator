<#include "../mcitems.ftl">
<#include "../procedures.java.ftl">

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

<@javacompress>
public class ${JavaModName}ItemExtensions {

	public static void load() {
		<#list itemextensions?filter(e -> e.compostLayerChance gt 0) as extension>
		CompostingChanceRegistry.INSTANCE.add(${mappedMCItemToItem(extension.item)}, ${extension.compostLayerChance}f);
		</#list>

		<#list itemextensions?filter(e -> e.enableFuel) as extension>
		<#if hasProcedure(extension.fuelSuccessCondition) || hasProcedure(extension.fuelPower)>
		<#-- Condition or procedure based fuel values are not supported by Fabric's FuelRegistry, see MIGRATION-REPORT.md -->
		<#else>
		FuelRegistry.INSTANCE.add(${mappedMCItemToItem(extension.item)}, ${extension.fuelPower.getFixedValue()});
		</#if>
		</#list>
	}
}
</@javacompress>
<#-- @formatter:on -->
