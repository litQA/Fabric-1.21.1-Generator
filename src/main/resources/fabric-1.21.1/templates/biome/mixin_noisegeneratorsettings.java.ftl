<#-- @formatter:off -->
package ${package}.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

import net.minecraft.core.Holder;
import net.minecraft.world.level.dimension.DimensionType;
import net.minecraft.world.level.levelgen.NoiseGeneratorSettings;
import net.minecraft.world.level.levelgen.SurfaceRules;

@Mixin(NoiseGeneratorSettings.class)
public class NoiseGeneratorSettingsMixin implements ${JavaModName}Biomes.${JavaModName}NoiseGeneratorSettings {

	@Unique private Holder<DimensionType> dimensionTypeReference;

	@Inject(method = "surfaceRule", at = @At("RETURN"), cancellable = true)
	private void onSurfaceRule(CallbackInfoReturnable<SurfaceRules.RuleSource> callbackInfo) {
		if (this.dimensionTypeReference != null) {
			SurfaceRules.RuleSource custom = ${JavaModName}Biomes.customSurfaceRules(this.dimensionTypeReference);
			if (custom != null) {
				callbackInfo.setReturnValue(SurfaceRules.sequence(custom, callbackInfo.getReturnValue()));
			}
		}
	}

	@Override public void set${modid}DimensionTypeReference(Holder<DimensionType> dimensionType) {
		this.dimensionTypeReference = dimensionType;
	}
}
<#-- @formatter:on -->

