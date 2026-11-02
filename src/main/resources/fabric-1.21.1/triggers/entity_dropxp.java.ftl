<#include "procedures.java.ftl">
import ${package}.trigger.${JavaModName}Triggers;
public class ${name}Procedure {
	static {
		${JavaModName}Triggers.DROP_XP.add((entity, dropped, original, source) -> {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "entity.getX()", "y": "entity.getY()", "z": "entity.getZ()",
					"droppedexperience": "dropped", "originalexperience": "original",
					"sourceentity": "source", "world": "entity.level()", "entity": "entity"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
		});
	}
	public ${name}Procedure() {
	}
