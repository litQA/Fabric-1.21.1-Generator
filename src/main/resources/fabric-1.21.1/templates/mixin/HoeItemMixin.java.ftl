<#-- @formatter:off -->
package ${package}.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

import net.minecraft.world.InteractionResult;
import net.minecraft.world.item.HoeItem;
import net.minecraft.world.item.context.UseOnContext;

@Mixin(HoeItem.class)
public class HoeItemMixin {

	@Inject(method = "useOn", at = @At("HEAD"))
	private void onUseOn(UseOnContext context, CallbackInfoReturnable<InteractionResult> callback) {
		if (context.getPlayer() != null)
			${JavaModName}Triggers.fireUseHoe(context.getPlayer(), context.getClickedPos(), context.getLevel().getBlockState(context.getClickedPos()));
	}
}
<#-- @formatter:on -->
