<#include "../procedures.java.ftl">

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

<@javacompress>
public class ${JavaModName}Dimensions {

	public static void load() {
		<#list dimensions as dimension>
			<#if dimension.enablePortal>
		${dimension.getModElement().getName()}Teleporter.registerPointOfInterest();
			</#if>
			<#if dimension.hasEffectsOrDimensionTriggers()>
		${dimension.getModElement().getName()}Dimension.load();
			</#if>
		</#list>
	}
}
</@javacompress>
<#-- @formatter:on -->

