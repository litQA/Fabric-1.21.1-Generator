<#include "procedures.java.ftl">
/* Fabric 1.21.1 approximation: bone meal use is derived from the block interaction callback and from the
   BonemealableBlock check, because Fabric has no dedicated bone meal event. See MIGRATION-REPORT.md. */
public class ${name}Procedure {

	static {
		net.fabricmc.fabric.api.event.player.UseBlockCallback.EVENT.register((player, world, hand, hitResult) -> {
			net.minecraft.world.item.ItemStack stack = player.getItemInHand(hand);
			net.minecraft.core.BlockPos pos = hitResult.getBlockPos();
			net.minecraft.world.level.block.state.BlockState state = world.getBlockState(pos);
			if (!stack.is(net.minecraft.world.item.Items.BONE_MEAL) || !(state.getBlock() instanceof net.minecraft.world.level.block.BonemealableBlock))
				return net.minecraft.world.InteractionResult.PASS;
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "pos.getX()",
					"y": "pos.getY()",
					"z": "pos.getZ()",
					"world": "world",
					"itemstack": "stack",
					"entity": "player",
					"blockstate": "state"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
			return net.minecraft.world.InteractionResult.PASS;
		});
	}

	public ${name}Procedure() {
	}
