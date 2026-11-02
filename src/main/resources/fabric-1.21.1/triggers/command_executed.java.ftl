<#include "procedures.java.ftl">
import ${package}.trigger.${JavaModName}Triggers;
public class ${name}Procedure {
	static {
		${JavaModName}Triggers.COMMAND.add((source, command, arguments) -> {
			net.minecraft.world.entity.Entity entity = source.getEntity();
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "entity != null ? entity.getX() : source.getPosition().x()",
					"y": "entity != null ? entity.getY() : source.getPosition().y()",
					"z": "entity != null ? entity.getZ() : source.getPosition().z()",
					"world": "source.getLevel()", "entity": "entity",
					"command": "command", "arguments": "arguments"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
		});
	}
	public ${name}Procedure() {
	}
