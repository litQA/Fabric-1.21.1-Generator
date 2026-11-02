<#-- @formatter:off -->
package ${package}.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

import net.minecraft.core.BlockPos;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.level.Level;
import net.minecraft.world.level.block.FarmBlock;
import net.minecraft.world.level.block.state.BlockState;

@Mixin(FarmBlock.class)
public class FarmBlockMixin {

	@Inject(method = "fallOn", at = @At("HEAD"))
	private void onFallOn(Level level, BlockState state, BlockPos pos, Entity entity, float distance, CallbackInfo callback) {
		${JavaModName}Triggers.fireFarmlandTrampled(level, pos, state, entity, distance);
	}
}
<#-- @formatter:on -->
