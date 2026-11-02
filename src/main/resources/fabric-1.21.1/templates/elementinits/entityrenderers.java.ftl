<#-- @formatter:off -->

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

import net.fabricmc.api.EnvType;
import net.fabricmc.api.Environment;
import net.fabricmc.fabric.api.client.rendering.v1.EntityRendererRegistry;

import net.minecraft.client.renderer.entity.ThrownItemRenderer;

@Environment(EnvType.CLIENT) public class ${JavaModName}EntityRenderers {

	public static void clientLoad() {
		<#list entities as entity>
			<#if entity.getModElement().getTypeString() == "projectile">
				<#if entity.isCustomModel()>
		EntityRendererRegistry.register(${JavaModName}Entities.${entity.getModElement().getRegistryNameUpper()}, ${entity.getModElement().getName()}Renderer::new);
				<#else>
		EntityRendererRegistry.register(${JavaModName}Entities.${entity.getModElement().getRegistryNameUpper()}, ThrownItemRenderer::new);
				</#if>
			<#elseif entity.getModElement().getTypeString() == "livingentity">
		EntityRendererRegistry.register(${JavaModName}Entities.${entity.getModElement().getRegistryNameUpper()}, ${entity.getModElement().getName()}Renderer::new);
				<#if entity.hasCustomProjectile()>
		EntityRendererRegistry.register(${JavaModName}Entities.${entity.getModElement().getRegistryNameUpper()}_PROJECTILE, ThrownItemRenderer::new);
				</#if>
			</#if>
		</#list>
	}

	// Start of user code block custom entity renderers
	// End of user code block custom entity renderers
}
<#-- @formatter:on -->
