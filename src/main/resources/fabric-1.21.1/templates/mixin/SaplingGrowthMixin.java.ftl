<#-- @formatter:off -->
package ${package}.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

import net.minecraft.core.BlockPos;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.util.RandomSource;
import net.minecraft.world.level.block.grower.TreeGrower;
import net.minecraft.world.level.block.state.BlockState;
import net.minecraft.world.level.chunk.ChunkGenerator;

@Mixin(TreeGrower.class)
public class SaplingGrowthMixin {

	@Inject(method = "growTree", at = @At("HEAD"), cancellable = true)
	private void onGrowTree(ServerLevel level, ChunkGenerator generator, BlockPos pos, BlockState state, RandomSource random, CallbackInfoReturnable<Boolean> callback) {
		if (!${JavaModName}Triggers.fireSaplingGrowth(level, pos, state))
			callback.setReturnValue(false);
	}
}
<#-- @formatter:on -->
