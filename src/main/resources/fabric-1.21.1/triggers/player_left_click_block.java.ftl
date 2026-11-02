<#include "procedures.java.ftl">
public class ${name}Procedure {

	static {
		net.fabricmc.fabric.api.event.player.AttackBlockCallback.EVENT.register((player, world, hand, pos, direction) -> {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "pos.getX()",
					"y": "pos.getY()",
					"z": "pos.getZ()",
					"world": "world",
					"entity": "player",
					"direction": "direction",
					"blockstate": "world.getBlockState(pos)"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
			return net.minecraft.world.InteractionResult.PASS;
		});
	}

	public ${name}Procedure() {
	}
