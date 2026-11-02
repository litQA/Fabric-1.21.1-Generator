<#include "procedures.java.ftl">
import ${package}.trigger.${JavaModName}Triggers;
public class ${name}Procedure {

	static {
		${JavaModName}Triggers.FALLS.add((entity, distance, multiplier, source) -> {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "entity.getX()",
					"y": "entity.getY()",
					"z": "entity.getZ()",
					"distance": "distance",
					"damagemultiplier": "multiplier",
					"world": "entity.level()",
					"entity": "entity"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
		});
	}

	public ${name}Procedure() {
	}
