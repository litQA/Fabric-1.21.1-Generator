<#-- @formatter:off -->
package ${package}.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

import net.minecraft.world.effect.MobEffects;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.player.Player;

@Mixin(Player.class)
public class PlayerCriticalMixin {

	@Inject(method = "attack", at = @At("HEAD"), cancellable = true)
	private void onAttack(Entity target, CallbackInfo callback) {
		Player player = (Player) (Object) this;
		if (!${JavaModName}Triggers.fireCriticalHit(player, target))
			callback.cancel();
	}
}
<#-- @formatter:on -->
