<#include "procedures.java.ftl">
public class ${name}Procedure {

	static {
		net.fabricmc.fabric.api.event.lifecycle.v1.ServerTickEvents.END_WORLD_TICK.register(level -> {
			for (net.minecraft.world.entity.Entity entity : level.getAllEntities()) {
				<#assign dependenciesCode>
					<@procedureDependenciesCode dependencies, {
						"x": "entity.getX()",
						"y": "entity.getY()",
						"z": "entity.getZ()",
						"world": "entity.level()",
						"entity": "entity"
					}/>
				</#assign>
				execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
			}
		});
	}

	public ${name}Procedure() {
	}
