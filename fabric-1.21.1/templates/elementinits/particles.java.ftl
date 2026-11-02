<#-- @formatter:off -->

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

import net.fabricmc.api.EnvType;
import net.fabricmc.api.Environment;
import net.fabricmc.fabric.api.client.particle.v1.ParticleFactoryRegistry;

@Environment(EnvType.CLIENT) public class ${JavaModName}Particles {

	public static void clientLoad() {
		<#list particles as particle>
		ParticleFactoryRegistry.getInstance().register(${JavaModName}ParticleTypes.${particle.getModElement().getRegistryNameUpper()}, ${particle.getModElement().getName()}Particle::provider);
		</#list>
	}
}
<#-- @formatter:on -->
