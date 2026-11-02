<#include "procedures.java.ftl">
import ${package}.trigger.${JavaModName}Triggers;
public class ${name}Procedure {
	static {
		${JavaModName}Triggers.PICKUP_XP.add(player -> {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "player.getX()", "y": "player.getY()", "z": "player.getZ()",
					"world": "player.level()", "entity": "player"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
		});
	}
	public ${name}Procedure() {
	}
