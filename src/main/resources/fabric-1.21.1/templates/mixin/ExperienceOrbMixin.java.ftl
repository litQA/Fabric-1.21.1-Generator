<#-- @formatter:off -->
package ${package}.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

import net.minecraft.world.entity.ExperienceOrb;
import net.minecraft.world.entity.player.Player;

@Mixin(ExperienceOrb.class)
public class ExperienceOrbMixin {

	@Inject(method = "playerTouch", at = @At("HEAD"))
	private void onPlayerTouch(Player player, CallbackInfo callback) {
		${JavaModName}Triggers.firePickupXp(player);
	}
}
<#-- @formatter:on -->
