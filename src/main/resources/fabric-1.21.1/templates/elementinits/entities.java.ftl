<#-- @formatter:off -->

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

public class ${JavaModName}Entities {

	<#list entities as entity>
		<#if entity.getModElement().getTypeString() == "projectile">
	public static final EntityType<${entity.getModElement().getName()}Entity> ${entity.getModElement().getRegistryNameUpper()} =
		register("${entity.getModElement().getRegistryName()}", EntityType.Builder.<${entity.getModElement().getName()}Entity>of(${entity.getModElement().getName()}Entity::new, MobCategory.MISC)
			.clientTrackingRange(64).updateInterval(1).sized(${entity.modelWidth}f, ${entity.modelHeight}f));
		<#elseif entity.getModElement().getTypeString() == "livingentity">
	public static final EntityType<${entity.getModElement().getName()}Entity> ${entity.getModElement().getRegistryNameUpper()} =
		register("${entity.getModElement().getRegistryName()}", EntityType.Builder.<${entity.getModElement().getName()}Entity>of(${entity.getModElement().getName()}Entity::new, ${entity.mobSpawningType})
			.clientTrackingRange(${entity.trackingRange}).updateInterval(3)
			<#if entity.immuneToFire>.fireImmune()</#if>
			<#if entity.mobModelName == "Biped">.ridingOffset(-0.6f)</#if>
			.sized(${entity.modelWidth}f, ${entity.modelHeight}f));
			<#if entity.hasCustomProjectile()>
	public static final EntityType<${entity.getModElement().getName()}EntityProjectile> ${entity.getModElement().getRegistryNameUpper()}_PROJECTILE =
		register("projectile_${entity.getModElement().getRegistryName()}", EntityType.Builder.<${entity.getModElement().getName()}EntityProjectile>of(${entity.getModElement().getName()}EntityProjectile::new, MobCategory.MISC)
			.clientTrackingRange(64).updateInterval(1).sized(0.5f, 0.5f));
			</#if>
		</#if>
	</#list>

	/**
	 * Registers the default attributes and spawn placements of the entity types. Called from the mod initializer.
	 */
	public static void load() {
		<#list entities as entity>
		<#if entity.getModElement().getTypeString() == "livingentity">
		FabricDefaultAttributeRegistry.register(${entity.getModElement().getRegistryNameUpper()}, ${entity.getModElement().getName()}Entity.createAttributes().build());
		${entity.getModElement().getName()}Entity.init();
		</#if>
		</#list>
	}

	// Start of user code block custom entities
	// End of user code block custom entities

	private static <T extends Entity> EntityType<T> register(String registryname, EntityType.Builder<T> entityTypeBuilder) {
		return Registry.register(BuiltInRegistries.ENTITY_TYPE, ResourceLocation.fromNamespaceAndPath(${JavaModName}.MODID, registryname), entityTypeBuilder.build(registryname));
	}
}
<#-- @formatter:on -->
