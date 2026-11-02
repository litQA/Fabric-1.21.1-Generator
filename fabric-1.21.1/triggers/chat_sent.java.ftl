<#include "procedures.java.ftl">
public class ${name}Procedure {

	static {
		net.fabricmc.fabric.api.message.v1.ServerMessageEvents.CHAT_MESSAGE.register((message, sender, params) -> {
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "sender.getX()",
					"y": "sender.getY()",
					"z": "sender.getZ()",
					"world": "sender.level()",
					"entity": "sender",
					"text": "message.signedContent()"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
		});
	}

	public ${name}Procedure() {
	}
