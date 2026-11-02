<#include "procedures.java.ftl">
import ${package}.trigger.${JavaModName}Triggers;
public class ${name}Procedure {
	static {
		${JavaModName}Triggers.FARMLAND_TRAMPLED.add((world, pos, state, entity, distance) -> {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "pos.getX()", "y": "pos.getY()", "z": "pos.getZ()",
					"world": "world", "entity": "entity", "blockstate": "state",
					"falldistance": "distance"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
		});
	}
	public ${name}Procedure() {
	}
