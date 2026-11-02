<#-- @formatter:off -->
package ${package}.item.inventory;

/*
 * Fabric 1.21.1 limitation: item based inventories need the loader item handler API, which is not
 * available on Fabric. The container below keeps its content in memory only, so items with an
 * inventory do not persist their inventory. See MIGRATION-REPORT.md.
 */
public class ${name}InventoryContainer {

	private final net.minecraft.world.SimpleContainer container;

	public ${name}InventoryContainer(net.minecraft.world.item.ItemStack stack) {
		this.container = new net.minecraft.world.SimpleContainer(9);
	}

	public net.minecraft.world.SimpleContainer getContainer() {
		return container;
	}
}
<#-- @formatter:on -->
