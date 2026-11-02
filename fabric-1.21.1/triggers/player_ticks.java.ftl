<#include "procedures.java.ftl">
public class ${name}Procedure {

	static {
		net.fabricmc.fabric.api.event.lifecycle.v1.ServerTickEvents.END_SERVER_TICK.register(server -> {
			for (net.minecraft.server.level.ServerPlayer player : server.getPlayerList().getPlayers()) {
				<#assign dependenciesCode>
					<@procedureDependenciesCode dependencies, {
						"x": "player.getX()",
						"y": "player.getY()",
						"z": "player.getZ()",
						"world": "player.level()",
						"entity": "player"
					}/>
				</#assign>
				execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
			}
		});
	}

	public ${name}Procedure() {
	}
