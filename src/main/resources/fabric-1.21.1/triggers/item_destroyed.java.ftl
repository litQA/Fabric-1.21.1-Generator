<#include "procedures.java.ftl">
import ${package}.trigger.${JavaModName}Triggers;
public class ${name}Procedure {

	static {
		${JavaModName}Triggers.ITEM_DESTROYED.add((entity, stack) -> {
			if (entity == null)
				return;
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "entity.getX()",
					"y": "entity.getY()",
					"z": "entity.getZ()",
					"world": "entity.level()",
					"entity": "entity",
					"itemstack": "stack"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
		});
	}

	public ${name}Procedure() {
	}
