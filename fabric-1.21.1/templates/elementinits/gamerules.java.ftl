<#-- @formatter:off -->

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

public class ${JavaModName}GameRules {

	<#list gamerules as gamerule>
		<#if gamerule.type == "Number">
	public static GameRules.Key<GameRules.IntegerValue> ${gamerule.getModElement().getRegistryNameUpper()};
		<#else>
	public static GameRules.Key<GameRules.BooleanValue> ${gamerule.getModElement().getRegistryNameUpper()};
		</#if>
	</#list>

	public static void load() {
	<@javacompress>
	<#list gamerules as gamerule>
		<#if gamerule.type == "Number">
		${gamerule.getModElement().getRegistryNameUpper()} =
				GameRuleRegistry.register("${StringUtils.lowercaseFirstLetter(gamerule.getModElement().getName())}",
				GameRules.Category.${gamerule.category}, GameRuleFactory.createIntRule(${gamerule.defaultValueNumber}));
		<#else>
		${gamerule.getModElement().getRegistryNameUpper()} =
				GameRuleRegistry.register("${StringUtils.lowercaseFirstLetter(gamerule.getModElement().getName())}",
				GameRules.Category.${gamerule.category}, GameRuleFactory.createBooleanRule(${gamerule.defaultValueLogic}));
		</#if>
	</#list>
	</@javacompress>
	}
}
<#-- @formatter:on -->
