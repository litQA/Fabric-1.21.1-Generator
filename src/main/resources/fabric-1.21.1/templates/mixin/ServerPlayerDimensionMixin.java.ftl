<#-- @formatter:off -->
package ${package}.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

import net.minecraft.server.level.ServerPlayer;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.level.portal.DimensionTransition;

@Mixin(ServerPlayer.class)
public class ServerPlayerDimensionMixin {

	@Inject(method = "changeDimension", at = @At("HEAD"), cancellable = true)
	private void onChangeDimension(DimensionTransition transition, CallbackInfoReturnable<Entity> callback) {
		if (!${JavaModName}Triggers.fireDimensionTravel((Entity) (Object) this))
			callback.setReturnValue((Entity) (Object) this);
	}
}
<#-- @formatter:on -->
