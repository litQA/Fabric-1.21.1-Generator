<#include "procedures.java.ftl">
public class ${name}Procedure {

	static {
		net.fabricmc.fabric.api.event.player.UseEntityCallback.EVENT.register((player, world, hand, target, hitResult) -> {
			if (hand != net.minecraft.world.InteractionHand.MAIN_HAND)
				return net.minecraft.world.InteractionResult.PASS;
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "target.getX()",
					"y": "target.getY()",
					"z": "target.getZ()",
					"world": "world",
					"entity": "target",
					"sourceentity": "player"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
			return net.minecraft.world.InteractionResult.PASS;
		});
	}

	public ${name}Procedure() {
	}
