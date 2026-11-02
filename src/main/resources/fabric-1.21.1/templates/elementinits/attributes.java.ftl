<#-- @formatter:off -->

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

import ${package}.mixin.AttributeSupplierAccessor;

public class ${JavaModName}Attributes {

	<#list attributes as attribute>
	public static Holder<Attribute> ${attribute.getModElement().getRegistryNameUpper()};
	</#list>

	public static void load() {
		<#list attributes as attribute>
		${attribute.getModElement().getRegistryNameUpper()} = register("${attribute.getModElement().getRegistryName()}",
				new RangedAttribute("attribute.${modid}.${attribute.getModElement().getRegistryName()}", ${attribute.defaultValue}, ${attribute.minValue}, ${attribute.maxValue}).setSyncable(true)
				<#if attribute.sentiment != "POSITIVE">.setSentiment(Attribute.Sentiment.${attribute.sentiment})</#if>);
		</#list>

		<#list attributes as attribute>
			<#if attribute.addToAllEntities>
		BuiltInRegistries.ENTITY_TYPE.stream().map((entityType) -> (EntityType<? extends LivingEntity>) entityType).filter(DefaultAttributes::hasSupplier)
				.forEach(entityType -> {
					FabricDefaultAttributeRegistry.register(entityType, addAttributeToEntity(DefaultAttributes.getSupplier(entityType), ${JavaModName}Attributes.${attribute.getModElement().getRegistryNameUpper()}));
				});
			<#else>
				<#if attribute.entities?has_content>
		List.of(
					<#list attribute.entities as entity>
					${generator.map(entity.getUnmappedValue(), "entities", 1)}<#sep>,
					</#list>
				).stream()
				.filter(DefaultAttributes::hasSupplier)
				.map(entityType -> (EntityType<? extends LivingEntity>) entityType)
				.collect(Collectors.toList()).forEach(entityType -> {
					FabricDefaultAttributeRegistry.register(entityType, addAttributeToEntity(DefaultAttributes.getSupplier(entityType), ${JavaModName}Attributes.${attribute.getModElement().getRegistryNameUpper()}));
				});
				</#if>
				<#if attribute.addToPlayers>
		FabricDefaultAttributeRegistry.register(EntityType.PLAYER, addAttributeToEntity(DefaultAttributes.getSupplier(EntityType.PLAYER), ${JavaModName}Attributes.${attribute.getModElement().getRegistryNameUpper()}));
				</#if>
			</#if>
		</#list>
	}

	private static AttributeSupplier addAttributeToEntity(AttributeSupplier existingSupplier, Holder<Attribute> newAttribute) {
		AttributeSupplier.Builder builder = AttributeSupplier.builder();
		AttributeSupplierAccessor accessor = (AttributeSupplierAccessor) existingSupplier;
		accessor.getInstances().forEach((attribute, instance) -> {
			builder.add(attribute, instance.getBaseValue());
		});
		return builder.add(newAttribute).build();
	}

	private static Holder<Attribute> register(String registryname, Attribute element) {
		return Registry.registerForHolder(BuiltInRegistries.ATTRIBUTE, ResourceLocation.fromNamespaceAndPath(${JavaModName}.MODID, registryname), element);
	}
}
<#-- @formatter:on -->

