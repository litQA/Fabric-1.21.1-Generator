<#-- @formatter:off -->
package ${package}.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

import net.minecraft.core.BlockPos;
import net.minecraft.world.InteractionResult;
import net.minecraft.world.item.BlockItem;
import net.minecraft.world.item.context.BlockPlaceContext;

@Mixin(BlockItem.class)
public class BlockItemMixin {

	@Inject(method = "place", at = @At("RETURN"))
	private void onPlace(BlockPlaceContext context, CallbackInfoReturnable<InteractionResult> callback) {
		if (callback.getReturnValue() != null && callback.getReturnValue().consumesAction()) {
			BlockPos pos = context.getClickedPos();
			${JavaModName}Triggers.fireBlockPlace(context.getLevel(), pos, context.getLevel().getBlockState(pos), context.getLevel().getBlockState(pos.relative(context.getClickedFace().getOpposite())), context.getPlayer());
		}
	}
}
<#-- @formatter:on -->
