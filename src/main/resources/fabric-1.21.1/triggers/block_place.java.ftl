<#include "procedures.java.ftl">
import ${package}.trigger.${JavaModName}Triggers;
public class ${name}Procedure {

	static {
		${JavaModName}Triggers.BLOCK_PLACE.add((world, pos, state, placedAgainst, entity) -> {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "pos.getX()",
					"y": "pos.getY()",
					"z": "pos.getZ()",
					"px": "entity != null ? entity.getX() : 0",
					"py": "entity != null ? entity.getY() : 0",
					"pz": "entity != null ? entity.getZ() : 0",
					"world": "world",
					"entity": "entity",
					"blockstate": "state",
					"placedagainst": "placedAgainst"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
		});
	}

	public ${name}Procedure() {
	}
