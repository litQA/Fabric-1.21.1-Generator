<#-- @formatter:off -->
package ${package}.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

import net.minecraft.server.level.ServerLevel;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.item.Item;
import net.minecraft.world.item.ItemStack;

import java.util.function.Consumer;

@Mixin(ItemStack.class)
public class ItemStackMixin {

	@Inject(method = "hurtAndBreak(ILnet/minecraft/server/level/ServerLevel;Lnet/minecraft/server/level/ServerPlayer;Ljava/util/function/Consumer;)V", at = @At("RETURN"))
	private void onDamage(int amount, ServerLevel level, ServerPlayer player, Consumer<Item> onBroken, CallbackInfo callback) {
		ItemStack stack = (ItemStack) (Object) this;
		if (stack.getCount() <= 0)
			${JavaModName}Triggers.fireItemDestroyed(player, stack);
	}
}
<#-- @formatter:on -->
