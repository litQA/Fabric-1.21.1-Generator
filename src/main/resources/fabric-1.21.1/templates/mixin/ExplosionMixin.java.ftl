<#-- @formatter:off -->
package ${package}.mixin;

import org.spongepowered.asm.mixin.Final;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Shadow;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

import net.minecraft.world.level.Explosion;
import net.minecraft.world.level.Level;

@Mixin(Explosion.class)
public class ExplosionMixin {

	@Shadow @Final private Level level;

	@Inject(method = "finalizeExplosion", at = @At("HEAD"))
	private void onFinalize(boolean spawnParticles, CallbackInfo callback) {
		Explosion explosion = (Explosion) (Object) this;
		${JavaModName}Triggers.fireExplosion(level, explosion.center().x, explosion.center().y, explosion.center().z);
	}
}
<#-- @formatter:on -->
