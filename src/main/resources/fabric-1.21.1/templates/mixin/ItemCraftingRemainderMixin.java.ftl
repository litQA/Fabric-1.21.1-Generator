<#-- @formatter:off -->
package ${package}.mixin;

import org.spongepowered.asm.mixin.Final;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Mutable;
import org.spongepowered.asm.mixin.Shadow;

import net.minecraft.world.item.Item;

import ${package}.item.CraftingRemainderSetter;

@Mixin(Item.class)
public abstract class ItemCraftingRemainderMixin implements CraftingRemainderSetter {

	@Shadow @Final @Mutable private Item craftingRemainingItem;

	@Override public void mcreatorSetCraftingRemainder(Item item) {
		this.craftingRemainingItem = item;
	}
}
<#-- @formatter:on -->
