<#-- @formatter:off -->
package ${package}.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

import net.minecraft.world.entity.TamableAnimal;
import net.minecraft.world.entity.player.Player;

@Mixin(TamableAnimal.class)
public class TamableAnimalMixin {

	@Inject(method = "tame", at = @At("RETURN"))
	private void onTame(Player player, CallbackInfo callback) {
		${JavaModName}Triggers.fireTamed((TamableAnimal) (Object) this, player);
	}
}
<#-- @formatter:on -->
