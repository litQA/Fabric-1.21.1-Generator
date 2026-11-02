<#-- @formatter:off -->
<#include "../procedures.java.ftl">

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

public class ${JavaModName}MobEffects {

	<#list potioneffects as effect>
	public static final Holder<MobEffect> ${effect.getModElement().getRegistryNameUpper()} = register("${effect.getModElement().getRegistryName()}", new ${effect.getModElement().getName()}MobEffect());
	</#list>

	<#assign effects_that_expire = potioneffects?filter(effect -> hasProcedure(effect.onExpired))>
	/**
	 * Forces the initialization of this class, which performs the actual mob effect registration.
	 */
	public static void load() {
		<#if effects_that_expire?size != 0>
		// Effects with an "on expired" procedure are handled by the trigger transport, which is delivered with the trigger phase.
		</#if>
	}

	private static Holder<MobEffect> register(String registryname, MobEffect effect) {
		return Registry.registerForHolder(BuiltInRegistries.MOB_EFFECT, ResourceLocation.fromNamespaceAndPath(${JavaModName}.MODID, registryname), effect);
	}
}
<#-- @formatter:on -->
