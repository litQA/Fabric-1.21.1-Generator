<#-- @formatter:off -->
package ${package}.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

import net.minecraft.core.BlockPos;
import net.minecraft.world.level.Level;
import net.minecraft.world.level.block.CropBlock;
import net.minecraft.world.level.block.state.BlockState;

@Mixin(CropBlock.class)
public class CropGrowthMixin {

	@Inject(method = "growCrops", at = @At("HEAD"), cancellable = true)
	private void onGrowCrops(Level level, BlockPos pos, BlockState state, CallbackInfo callback) {
		if (!${JavaModName}Triggers.fireCropGrowth(level, pos, state))
			callback.cancel();
	}
}
<#-- @formatter:on -->
