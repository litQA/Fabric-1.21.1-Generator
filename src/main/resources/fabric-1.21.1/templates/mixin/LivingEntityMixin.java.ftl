<#-- @formatter:off -->
package ${package}.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

import net.minecraft.world.damagesource.DamageSource;
import net.minecraft.world.entity.LivingEntity;

@Mixin(LivingEntity.class)
public class LivingEntityMixin {

	@Inject(method = "heal", at = @At("RETURN"))
	private void onHeal(float amount, CallbackInfo callback) {
		${JavaModName}Triggers.fireHealed((LivingEntity) (Object) this, amount);
	}

	@Inject(method = "causeFallDamage", at = @At("HEAD"))
	private void onFall(float distance, float multiplier, DamageSource source, CallbackInfoReturnable<Boolean> callback) {
		${JavaModName}Triggers.fireFalls((LivingEntity) (Object) this, distance, multiplier, source);
	}

	@Inject(method = "jumpFromGround", at = @At("HEAD"))
	private void onJump(CallbackInfo callback) {
		${JavaModName}Triggers.fireJumps((LivingEntity) (Object) this);
	}

	@Inject(method = "hurt", at = @At("HEAD"))
	private void onHurt(DamageSource source, float amount, CallbackInfoReturnable<Boolean> callback) {
		LivingEntity self = (LivingEntity) (Object) this;
		if (self.isDamageSourceBlocked(source))
			${JavaModName}Triggers.fireShieldBlock(self, source, amount);
	}

	@Inject(method = "setItemInHand", at = @At("HEAD"))
	private void onSetItemInHand(net.minecraft.world.InteractionHand hand, ItemStack stack, CallbackInfo callback) {
		if (hand == net.minecraft.world.InteractionHand.OFF_HAND) {
			LivingEntity self = (LivingEntity) (Object) this;
			${JavaModName}Triggers.fireSwitchHand(self, self.getMainHandItem(), stack);
		}
	}

	@Inject(method = "startUsingItem", at = @At("HEAD"))
	private void onStartUsing(net.minecraft.world.InteractionHand hand, CallbackInfo callback) {
		LivingEntity self = (LivingEntity) (Object) this;
		${JavaModName}Triggers.fireUseItemStart(self, self.getItemInHand(hand), self.getUseItemRemainingTicks());
	}

	@Inject(method = "stopUsingItem", at = @At("HEAD"))
	private void onStopUsing(CallbackInfo callback) {
		LivingEntity self = (LivingEntity) (Object) this;
		if (!self.getUseItem().isEmpty())
			${JavaModName}Triggers.fireUseItemStop(self, self.getUseItem(), self.getUseItemRemainingTicks());
	}

	@Inject(method = "completeUsingItem", at = @At("HEAD"))
	private void onCompleteUsing(CallbackInfo callback) {
		LivingEntity self = (LivingEntity) (Object) this;
		${JavaModName}Triggers.fireUseItemFinish(self, self.getUseItem(), self.getUseItemRemainingTicks());
	}

	@Inject(method = "dropExperience", at = @At("HEAD"))
	private void onDropExperience(net.minecraft.world.entity.Entity source, CallbackInfo callback) {
		LivingEntity self = (LivingEntity) (Object) this;
		${JavaModName}Triggers.fireDropXp(self, 0, 0, source);
	}
	@Inject(method = "checkTotemDeathProtection", at = @At("RETURN"))
	private void onTotem(DamageSource source, CallbackInfoReturnable<Boolean> callback) {
		if (callback.getReturnValueZ())
			${JavaModName}Triggers.fireUseTotem((LivingEntity) (Object) this, source, ((LivingEntity) (Object) this).getOffhandItem());
	}
}
<#-- @formatter:on -->
