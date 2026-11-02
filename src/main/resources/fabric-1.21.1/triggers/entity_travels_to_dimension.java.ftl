<#include "procedures.java.ftl">
import ${package}.trigger.${JavaModName}Triggers;
public class ${name}Procedure {
	static {
		${JavaModName}Triggers.DIMENSION_TRAVEL.add(entity -> {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "entity.getX()", "y": "entity.getY()", "z": "entity.getZ()",
					"world": "entity.level()", "dimension": "entity.level().dimension()", "entity": "entity"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
			return true;
		});
	}
	public ${name}Procedure() {
	}
