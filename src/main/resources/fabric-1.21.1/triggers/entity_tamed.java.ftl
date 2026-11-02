<#include "procedures.java.ftl">
import ${package}.trigger.${JavaModName}Triggers;
public class ${name}Procedure {

	static {
		${JavaModName}Triggers.TAMED.add((animal, player) -> {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "animal.getX()",
					"y": "animal.getY()",
					"z": "animal.getZ()",
					"world": "animal.level()",
					"entity": "animal",
					"sourceentity": "player"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
		});
	}

	public ${name}Procedure() {
	}
