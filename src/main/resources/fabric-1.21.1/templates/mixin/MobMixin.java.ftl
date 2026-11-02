<#-- @formatter:off -->
package ${package}.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.Mob;

@Mixin(Mob.class)
public class MobMixin {

	@Inject(method = "setTarget", at = @At("HEAD"))
	private void onSetTarget(LivingEntity target, CallbackInfo callback) {
		Mob mob = (Mob) (Object) this;
		${JavaModName}Triggers.fireTargetChange(mob, mob.getTarget(), target);
	}
}
<#-- @formatter:on -->
