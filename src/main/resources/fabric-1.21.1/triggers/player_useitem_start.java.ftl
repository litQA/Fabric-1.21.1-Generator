<#include "procedures.java.ftl">
import ${package}.trigger.${JavaModName}Triggers;
public class ${name}Procedure {
	static {
		${JavaModName}Triggers.USE_ITEM_START.add((entity, stack, duration) -> {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "entity.getX()", "y": "entity.getY()", "z": "entity.getZ()",
					"itemstack": "stack", "duration": "duration",
					"world": "entity.level()", "entity": "entity"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
		});
	}
	public ${name}Procedure() {
	}
