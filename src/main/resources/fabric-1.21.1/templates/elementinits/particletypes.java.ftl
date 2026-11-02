<#-- @formatter:off -->

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

import net.fabricmc.fabric.api.particle.v1.FabricParticleTypes;

public class ${JavaModName}ParticleTypes {

	<#list particles as particle>
	public static final SimpleParticleType ${particle.getModElement().getRegistryNameUpper()} = register("${particle.getModElement().getRegistryName()}", ${particle.alwaysShow});
	</#list>

	/**
	 * Forces the initialization of this class, which performs the actual particle type registration.
	 */
	public static void load() {
	}

	private static SimpleParticleType register(String registryname, boolean alwaysShow) {
		return Registry.register(BuiltInRegistries.PARTICLE_TYPE, ResourceLocation.fromNamespaceAndPath(${JavaModName}.MODID, registryname), FabricParticleTypes.simple(alwaysShow));
	}
}
<#-- @formatter:on -->

