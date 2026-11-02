<#include "procedures.java.ftl">
import ${package}.trigger.${JavaModName}Triggers;
public class ${name}Procedure {

	static {
		${JavaModName}Triggers.TARGET_CHANGE.add((mob, oldTarget, newTarget) -> {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "mob.getX()",
					"y": "mob.getY()",
					"z": "mob.getZ()",
					"world": "mob.level()",
					"entity": "oldTarget",
					"sourceentity": "mob"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
		});
	}

	public ${name}Procedure() {
	}
