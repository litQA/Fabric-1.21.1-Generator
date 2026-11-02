<#include "procedures.java.ftl">
public class ${name}Procedure {

	static {
		net.fabricmc.fabric.api.entity.event.v1.ServerPlayerEvents.AFTER_RESPAWN.register((oldPlayer, newPlayer, alive) -> {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "newPlayer.getX()",
					"y": "newPlayer.getY()",
					"z": "newPlayer.getZ()",
					"world": "newPlayer.level()",
					"entity": "newPlayer",
					"endconquered": "false"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
		});
	}

	public ${name}Procedure() {
	}
