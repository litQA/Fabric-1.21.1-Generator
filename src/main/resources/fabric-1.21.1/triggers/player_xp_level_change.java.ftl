<#include "procedures.java.ftl">
import ${package}.trigger.${JavaModName}Triggers;
public class ${name}Procedure {
	static {
		${JavaModName}Triggers.XP_LEVEL_CHANGE.add((player, levels) -> {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "player.getX()", "y": "player.getY()", "z": "player.getZ()",
					"world": "player.level()", "entity": "player", "amount": "levels"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
		});
	}
	public ${name}Procedure() {
	}
