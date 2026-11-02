<#include "procedures.java.ftl">
import ${package}.trigger.${JavaModName}Triggers;
public class ${name}Procedure {

	static {
		${JavaModName}Triggers.ITEM_CRAFTED.add((player, stack) -> {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "player.getX()",
					"y": "player.getY()",
					"z": "player.getZ()",
					"world": "player.level()",
					"entity": "player",
					"itemstack": "stack"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
		});
	}

	public ${name}Procedure() {
	}
