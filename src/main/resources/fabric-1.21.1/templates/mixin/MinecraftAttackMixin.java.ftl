<#-- @formatter:off -->
package ${package}.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Shadow;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

import net.minecraft.client.Minecraft;
import net.minecraft.client.player.LocalPlayer;

@Mixin(Minecraft.class)
public class MinecraftAttackMixin {

	@Shadow public LocalPlayer player;

	@Inject(method = "startAttack", at = @At("HEAD"))
	private void onStartAttack(CallbackInfoReturnable<Boolean> callback) {
		if (this.player != null)
			${JavaModName}Triggers.fireLeftClickAir(this.player);
	}
}
<#-- @formatter:on -->
