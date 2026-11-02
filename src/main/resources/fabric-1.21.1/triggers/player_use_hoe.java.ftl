<#include "procedures.java.ftl">
import ${package}.trigger.${JavaModName}Triggers;
public class ${name}Procedure {
	static {
		${JavaModName}Triggers.USE_HOE.add((player, pos, state) -> {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "pos.getX()", "y": "pos.getY()", "z": "pos.getZ()",
					"world": "player.level()", "entity": "player", "blockstate": "state"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
		});
	}
	public ${name}Procedure() {
	}
