<#-- @formatter:off -->

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

public class ${JavaModName}Potions {

	<#list potions as potion>
	public static final Potion ${potion.getModElement().getRegistryNameUpper()} = register("${potion.getModElement().getRegistryName()}",
			new Potion(
				<#list potion.effects as effect>
				new MobEffectInstance(${effect.effect}, ${effect.getDuration()}, ${effect.amplifier}, ${effect.ambient}, ${effect.showParticles})<#sep>,
				</#list>
			));
	</#list>

	/**
	 * Forces the initialization of this class, which performs the actual potion registration.
	 */
	public static void load() {
	}

	private static Potion register(String registryname, Potion potion) {
		return Registry.register(BuiltInRegistries.POTION, ResourceLocation.fromNamespaceAndPath(${JavaModName}.MODID, registryname), potion);
	}
}
<#-- @formatter:on -->
