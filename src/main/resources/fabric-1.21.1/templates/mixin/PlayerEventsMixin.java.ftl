<#-- @formatter:off -->
package ${package}.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

import net.minecraft.world.entity.item.ItemEntity;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.item.ItemStack;

@Mixin(Player.class)
public class PlayerEventsMixin {

	@Inject(method = "stopSleepInBed", at = @At("HEAD"))
	private void onWakeUp(boolean skipSleepTimer, boolean updateLevelForSleepingPlayers, CallbackInfo callback) {
		${JavaModName}Triggers.fireWakesUp((Player) (Object) this);
	}

	@Inject(method = "giveExperiencePoints", at = @At("HEAD"))
	private void onXpChange(int amount, CallbackInfo callback) {
		${JavaModName}Triggers.fireXpChange((Player) (Object) this, amount);
	}

	@Inject(method = "giveExperienceLevels", at = @At("HEAD"))
	private void onXpLevelChange(int levels, CallbackInfo callback) {
		${JavaModName}Triggers.fireXpLevelChange((Player) (Object) this, levels);
	}

	@Inject(method = "drop(Lnet/minecraft/world/item/ItemStack;ZZ)Lnet/minecraft/world/entity/item/ItemEntity;", at = @At("RETURN"))
	private void onDrop(ItemStack stack, boolean dropAround, boolean traceItem, CallbackInfoReturnable<ItemEntity> callback) {
		ItemEntity dropped = callback.getReturnValue();
		if (dropped != null)
			${JavaModName}Triggers.fireGemDropped((Player) (Object) this, dropped.getItem());
	}
}
<#-- @formatter:on -->
