<#-- @formatter:off -->
package ${package}.item;

/**
 * Implemented on every item through a mixin, so items that stay in the crafting grid can point the
 * vanilla crafting remainder at themselves.
 */
public interface CraftingRemainderSetter {

	void mcreatorSetCraftingRemainder(net.minecraft.world.item.Item item);
}
<#-- @formatter:on -->
