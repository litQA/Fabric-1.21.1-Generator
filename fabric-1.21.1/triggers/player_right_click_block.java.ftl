<#include "procedures.java.ftl">
public class ${name}Procedure {

	static {
		net.fabricmc.fabric.api.event.player.UseBlockCallback.EVENT.register((player, world, hand, hitResult) -> {
			if (hand != net.minecraft.world.InteractionHand.MAIN_HAND)
				return net.minecraft.world.InteractionResult.PASS;
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "hitResult.getBlockPos().getX()",
					"y": "hitResult.getBlockPos().getY()",
					"z": "hitResult.getBlockPos().getZ()",
					"world": "world",
					"entity": "player",
					"direction": "hitResult.getDirection()",
					"blockstate": "world.getBlockState(hitResult.getBlockPos())"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
			return net.minecraft.world.InteractionResult.PASS;
		});
	}

	public ${name}Procedure() {
	}
