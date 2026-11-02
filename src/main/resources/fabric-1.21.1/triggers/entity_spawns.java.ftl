<#include "procedures.java.ftl">
/* Fabric 1.21.1 approximation: entity spawns is derived from the entity load event, because server side
   spawn reasons are not exposed through a Fabric event. See MIGRATION-REPORT.md. */
public class ${name}Procedure {

	static {
		net.fabricmc.fabric.api.event.lifecycle.v1.ServerEntityEvents.ENTITY_LOAD.register((entity, world) -> {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "entity.getX()",
					"y": "entity.getY()",
					"z": "entity.getZ()",
					"world": "world",
					"entity": "entity"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
		});
	}

	public ${name}Procedure() {
	}
