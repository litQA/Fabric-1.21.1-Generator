<#-- @formatter:off -->
package ${package}.mixin;

import org.spongepowered.asm.mixin.Final;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Mutable;
import org.spongepowered.asm.mixin.Shadow;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

import net.minecraft.resources.ResourceKey;
import net.minecraft.world.level.biome.Biome;
import net.minecraft.world.level.biome.Climate;
import net.minecraft.world.level.biome.MultiNoiseBiomeSourceParameterList;

import java.util.function.Function;
@Mixin(MultiNoiseBiomeSourceParameterList.Preset.class)
public class BiomeSourcePresetMixin {

	@Mutable @Shadow @Final private MultiNoiseBiomeSourceParameterList.Preset.SourceProvider provider;

	@Inject(method = "<init>", at = @At("RETURN"))
	private void onPresetCreated(ResourceLocation idArg, MultiNoiseBiomeSourceParameterList.Preset.SourceProvider ignored, CallbackInfo callbackInfo) {
		if (idArg.equals(${JavaModName}Biomes.OVERWORLD_BIOMESOURCE_PRESET_ID) || idArg.equals(${JavaModName}Biomes.NETHER_BIOMESOURCE_PRESET_ID)) {
			final MultiNoiseBiomeSourceParameterList.Preset.SourceProvider existingProvider = this.provider;
			this.provider = new MultiNoiseBiomeSourceParameterList.Preset.SourceProvider() {
				@Override public <T> Climate.ParameterList<T> apply(Function<ResourceKey<Biome>, T> lookup) {
					return ${JavaModName}Biomes.adaptPresetParameterList(idArg, existingProvider.apply(lookup), lookup);
				}
			};
		}
	}
}
<#-- @formatter:on -->

