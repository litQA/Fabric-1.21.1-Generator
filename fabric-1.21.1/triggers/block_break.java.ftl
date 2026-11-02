<#include "procedures.java.ftl">
public class ${name}Procedure {

	static {
		net.fabricmc.fabric.api.event.player.PlayerBlockBreakEvents.AFTER.register((world, player, pos, state, blockEntity) -> {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "pos.getX()",
					"y": "pos.getY()",
					"z": "pos.getZ()",
					"px": "player.getX()",
					"py": "player.getY()",
					"pz": "player.getZ()",
					"world": "world",
					"entity": "player",
					"blockstate": "state"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
		});
	}

	public ${name}Procedure() {
	}
