<#-- @formatter:off -->
package ${package}.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

import net.minecraft.world.entity.player.Player;
import net.minecraft.world.entity.projectile.FishingHook;
import net.minecraft.world.item.ItemStack;

@Mixin(FishingHook.class)
public class FishingHookMixin {

	@Inject(method = "retrieve", at = @At("HEAD"))
	private void onRetrieve(ItemStack stack, CallbackInfoReturnable<Integer> callback) {
		Player owner = ((FishingHook) (Object) this).getPlayerOwner();
		if (owner != null)
			${JavaModName}Triggers.fireFishedItem(owner, stack);
	}
}
<#-- @formatter:on -->
