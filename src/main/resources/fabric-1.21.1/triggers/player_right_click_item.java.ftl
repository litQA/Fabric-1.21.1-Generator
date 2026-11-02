<#include "procedures.java.ftl">
public class ${name}Procedure {

	static {
		net.fabricmc.fabric.api.event.player.UseItemCallback.EVENT.register((player, world, hand) -> {
			if (hand != net.minecraft.world.InteractionHand.MAIN_HAND)
				return net.minecraft.world.InteractionResultHolder.pass(player.getItemInHand(hand));
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "player.getX()",
					"y": "player.getY()",
					"z": "player.getZ()",
					"world": "world",
					"entity": "player"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
			return net.minecraft.world.InteractionResultHolder.pass(player.getItemInHand(hand));
		});
	}

	public ${name}Procedure() {
	}
