<#-- @formatter:off -->

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

public class ${JavaModName}BlockEntities {

	<#list w.getGElementsOfType('plant')?filter(e -> e.hasTileEntity) as plant>
	public static final BlockEntityType<${plant.getModElement().getName()}BlockEntity> ${plant.getModElement().getRegistryNameUpper()}_PLANT =
		register("${plant.getModElement().getRegistryName()}", ${JavaModName}Blocks.${plant.getModElement().getRegistryNameUpper()}, ${plant.getModElement().getName()}BlockEntity::new);
	</#list>
	<#list blockentities as blockentity>
	public static final BlockEntityType<${blockentity.getModElement().getName()}BlockEntity> ${blockentity.getModElement().getRegistryNameUpper()} =
		register("${blockentity.getModElement().getRegistryName()}", ${JavaModName}Blocks.${blockentity.getModElement().getRegistryNameUpper()}, ${blockentity.getModElement().getName()}BlockEntity::new);
	</#list>

	/**
	 * Forces the initialization of this class, which performs the actual block entity type registration.
	 */
	public static void load() {
	}

	// Start of user code block custom block entities
	// End of user code block custom block entities

	private static <T extends BlockEntity> BlockEntityType<T> register(String registryname, Block block, BlockEntityType.BlockEntitySupplier<T> supplier) {
		return Registry.register(BuiltInRegistries.BLOCK_ENTITY_TYPE, ResourceLocation.fromNamespaceAndPath(${JavaModName}.MODID, registryname),
				BlockEntityType.Builder.of(supplier, block).build());
	}
}
<#-- @formatter:on -->

