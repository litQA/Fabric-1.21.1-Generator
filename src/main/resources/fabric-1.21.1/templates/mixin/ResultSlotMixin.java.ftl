<#-- @formatter:off -->
package ${package}.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

import net.minecraft.world.entity.player.Player;
import net.minecraft.world.inventory.ResultSlot;
import net.minecraft.world.item.ItemStack;

@Mixin(ResultSlot.class)
public class ResultSlotMixin {

	@Inject(method = "onTake", at = @At("RETURN"))
	private void onTake(Player player, ItemStack stack, CallbackInfo callback) {
		${JavaModName}Triggers.fireItemCrafted(player, stack);
	}
}
<#-- @formatter:on -->
