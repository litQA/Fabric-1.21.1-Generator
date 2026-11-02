<#-- @formatter:off -->
<#include "../procedures.java.ftl">

package ${package}.fluid;

import net.fabricmc.api.EnvType;
import net.fabricmc.api.Environment;
import net.fabricmc.fabric.api.blockrenderlayer.v1.BlockRenderLayerMap;
import net.fabricmc.fabric.api.client.render.fluid.v1.FluidRenderHandlerRegistry;
import net.fabricmc.fabric.api.client.render.fluid.v1.SimpleFluidRenderHandler;

import net.minecraft.client.renderer.RenderType;
import net.minecraft.core.BlockPos;
import net.minecraft.core.particles.ParticleOptions;
import net.minecraft.core.Direction;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.sounds.SoundEvent;
import net.minecraft.sounds.SoundEvents;
import net.minecraft.world.item.Item;
import net.minecraft.world.item.Items;
import net.minecraft.world.level.BlockGetter;
import net.minecraft.world.level.Level;
import net.minecraft.world.level.LevelAccessor;
import net.minecraft.world.level.LevelReader;
import net.minecraft.world.level.block.Block;
import net.minecraft.world.level.block.Blocks;
import net.minecraft.world.level.block.LiquidBlock;
import net.minecraft.world.level.block.entity.BlockEntity;
import net.minecraft.world.level.block.state.BlockState;
import net.minecraft.world.level.block.state.StateDefinition;
import net.minecraft.world.level.material.FlowingFluid;
import net.minecraft.world.level.material.Fluid;
import net.minecraft.world.level.material.FluidState;
import net.minecraft.world.level.material.Fluids;
import net.minecraft.world.phys.Vec3;

import java.util.Optional;

<@javacompress>
public abstract class ${name}Fluid extends FlowingFluid {

	@Override protected boolean canConvertToSource(Level level) {
		return ${data.canMultiply};
	}

	@Override protected void beforeDestroyingBlock(LevelAccessor level, BlockPos pos, BlockState state) {
		BlockEntity blockEntity = state.hasBlockEntity() ? level.getBlockEntity(pos) : null;
		Block.dropResources(state, level, pos, blockEntity);
	<#if hasProcedure(data.beforeReplacingBlock)>
		<@procedureCode data.beforeReplacingBlock, {
			"x": "pos.getX()",
			"y": "pos.getY()",
			"z": "pos.getZ()",
			"world": "level",
			"blockstate": "state"
		}/>
	</#if>
	}

	@Override protected boolean canBeReplacedWith(FluidState state, BlockGetter level, BlockPos pos, Fluid fluid, Direction direction) {
		return direction == Direction.DOWN && !isSame(fluid);
	}

	@Override public Fluid getFlowing() {
		return ${JavaModName}Fluids.FLOWING_${REGISTRYNAME};
	}

	@Override public Fluid getSource() {
		return ${JavaModName}Fluids.${REGISTRYNAME};
	}

	@Override public float getExplosionResistance() {
		return ${data.resistance}f;
	}

	@Override public int getTickDelay(LevelReader level) {
		return ${data.flowRate};
	}

	@Override protected int getDropOff(LevelReader level) {
		return ${data.levelDecrease};
	}

	@Override protected int getSlopeFindDistance(LevelReader level) {
		return ${data.slopeFindDistance};
	}

	@Override public Item getBucket() {
		return <#if data.generateBucket>${JavaModName}Items.${REGISTRYNAME}_BUCKET<#else>Items.AIR</#if>;
	}

	@Override protected BlockState createLegacyBlock(FluidState state) {
		Block block = ${JavaModName}Blocks.${REGISTRYNAME};
		if (block != null)
			return block.defaultBlockState().setValue(LiquidBlock.LEVEL, getLegacyLevel(state));
		return Blocks.AIR.defaultBlockState();
	}

	@Override public boolean isSame(Fluid fluid) {
		return fluid == getSource() || fluid == getFlowing();
	}

	@Override public Optional<SoundEvent> getPickupSound() {
		return Optional.of(SoundEvents.BUCKET_FILL);
	}

	<#if data.spawnParticles>
	@Override public ParticleOptions getDripParticle() {
		return ${data.dripParticle};
	}
	</#if>

	<#if data.flowStrength != 1>
	@Override public Vec3 getFlow(BlockGetter world, BlockPos pos, FluidState fluidstate) {
		return super.getFlow(world, pos, fluidstate).scale(${data.flowStrength});
	}
	</#if>

	<#if hasProcedure(data.flowCondition)>
	@Override protected void spread(Level world, BlockPos fromPos, FluidState fluidIn) {
		int x = fromPos.getX();
		int y = fromPos.getY();
		int z = fromPos.getZ();
		if (<@procedureOBJToConditionCode data.flowCondition/>)
			super.spread(world, fromPos, fluidIn);
	}
	</#if>

	public static class Source extends ${name}Fluid {
		public int getAmount(FluidState state) {
			return 8;
		}

		public boolean isSource(FluidState state) {
			return true;
		}
	}

	public static class Flowing extends ${name}Fluid {
		protected void createFluidStateDefinition(StateDefinition.Builder<Fluid, FluidState> builder) {
			super.createFluidStateDefinition(builder);
			builder.add(LEVEL);
		}

		public int getAmount(FluidState state) {
			return state.getValue(LEVEL);
		}

		public boolean isSource(FluidState state) {
			return false;
		}
	}

	@Environment(EnvType.CLIENT) public static void clientLoad() {
		FluidRenderHandlerRegistry.INSTANCE.register(${JavaModName}Fluids.${REGISTRYNAME}, ${JavaModName}Fluids.FLOWING_${REGISTRYNAME}, new SimpleFluidRenderHandler(
			ResourceLocation.parse("${data.textureStill.format("%s:block/%s")}"),
			ResourceLocation.parse("${data.textureFlowing.format("%s:block/%s")}")
			<#if data.textureRenderOverlay?has_content>, ResourceLocation.parse("${data.textureRenderOverlay.format("%s:textures/%s")}.png")</#if>
		));
		BlockRenderLayerMap.INSTANCE.putFluids(RenderType.translucent(), ${JavaModName}Fluids.${REGISTRYNAME}, ${JavaModName}Fluids.FLOWING_${REGISTRYNAME});
	}
}
</@javacompress>
<#-- @formatter:on -->
