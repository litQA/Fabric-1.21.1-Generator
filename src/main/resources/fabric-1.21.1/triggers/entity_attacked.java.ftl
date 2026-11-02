<#include "procedures.java.ftl">
public class ${name}Procedure {

	static {
		net.fabricmc.fabric.api.entity.event.v1.ServerLivingEntityEvents.ALLOW_DAMAGE.register((entity, source, amount) -> {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "entity.getX()",
					"y": "entity.getY()",
					"z": "entity.getZ()",
					"amount": "amount",
					"world": "entity.level()",
					"entity": "entity",
					"damagesource": "source",
					"sourceentity": "source.getEntity()",
					"immediatesourceentity": "source.getDirectEntity()"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
			return true;
		});
	}

	public ${name}Procedure() {
	}
