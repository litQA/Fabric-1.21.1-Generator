<#-- @formatter:off -->
package ${package}.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

import net.minecraft.world.entity.item.ItemEntity;

@Mixin(ItemEntity.class)
public class ItemEntityMixin {

	@org.spongepowered.asm.mixin.Unique private ItemStack mcreatorPickupStack = ItemStack.EMPTY;

	@Inject(method = "playerTouch", at = @At("HEAD"))
	private void onPlayerTouchStart(net.minecraft.world.entity.player.Player player, CallbackInfo callback) {
		this.mcreatorPickupStack = ((ItemEntity) (Object) this).getItem().copy();
	}

	@Inject(method = "playerTouch", at = @At("RETURN"))
	private void onPlayerTouchEnd(net.minecraft.world.entity.player.Player player, CallbackInfo callback) {
		ItemEntity entity = (ItemEntity) (Object) this;
		if (entity.isRemoved() && !this.mcreatorPickupStack.isEmpty())
			${JavaModName}Triggers.fireItemPickup(player, this.mcreatorPickupStack);
	}
	@Inject(method = "tick", at = @At("RETURN"))
	private void onTick(CallbackInfo callback) {
		ItemEntity entity = (ItemEntity) (Object) this;
		if (entity.isRemoved() && !entity.getItem().isEmpty())
			${JavaModName}Triggers.fireItemExpired(entity, entity.getItem().copy());
	}
}
<#-- @formatter:on -->
