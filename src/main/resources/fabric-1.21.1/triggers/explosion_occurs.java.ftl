<#include "procedures.java.ftl">
import ${package}.trigger.${JavaModName}Triggers;
public class ${name}Procedure {
	static {
		${JavaModName}Triggers.EXPLOSION.add((world, x, y, z) -> {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "x", "y": "y", "z": "z", "world": "world"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
		});
	}
	public ${name}Procedure() {
	}
