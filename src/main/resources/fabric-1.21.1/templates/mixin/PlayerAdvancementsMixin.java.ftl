<#-- @formatter:off -->
package ${package}.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Shadow;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

import net.minecraft.advancements.AdvancementHolder;
import net.minecraft.server.PlayerAdvancements;
import net.minecraft.server.level.ServerPlayer;

@Mixin(PlayerAdvancements.class)
public class PlayerAdvancementsMixin {

	@Shadow private ServerPlayer player;

	@Inject(method = "award", at = @At("RETURN"))
	private void onAward(AdvancementHolder advancement, String criterion, CallbackInfoReturnable<Boolean> callback) {
		if (callback.getReturnValueZ() && this.player != null)
			${JavaModName}Triggers.fireAdvancement(this.player, advancement);
	}
}
<#-- @formatter:on -->
