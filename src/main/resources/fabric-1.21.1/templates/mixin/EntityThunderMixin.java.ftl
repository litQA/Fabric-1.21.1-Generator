<#-- @formatter:off -->
package ${package}.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

import net.minecraft.server.level.ServerLevel;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.LightningBolt;

@Mixin(Entity.class)
public class EntityThunderMixin {

	@Inject(method = "thunderHit", at = @At("HEAD"))
	private void onThunderHit(ServerLevel level, LightningBolt bolt, CallbackInfo callback) {
		${JavaModName}Triggers.fireStruckByLightning((Entity) (Object) this, bolt);
	}
}
<#-- @formatter:on -->
