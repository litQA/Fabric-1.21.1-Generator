<#-- @formatter:off -->
package ${package}.mixin;

import com.mojang.datafixers.util.Either;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

import net.minecraft.core.BlockPos;
import net.minecraft.util.Unit;
import net.minecraft.world.entity.player.Player;

@Mixin(Player.class)
public class PlayerSleepMixin {

	@Inject(method = "startSleepInBed", at = @At("RETURN"))
	private void onSleep(BlockPos pos, CallbackInfoReturnable<Either<Player.BedSleepingProblem, Unit>> callback) {
		if (callback.getReturnValue() != null && callback.getReturnValue().left().isEmpty())
			${JavaModName}Triggers.fireInBed((Player) (Object) this, pos);
	}
}
<#-- @formatter:on -->
