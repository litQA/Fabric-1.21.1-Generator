<#include "procedures.java.ftl">
public class ${name}Procedure {

	static {
		net.fabricmc.fabric.api.event.lifecycle.v1.ServerLifecycleEvents.SERVER_STARTED.register(server -> {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"world": "server.overworld()"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
		});
	}

	public ${name}Procedure() {
	}
