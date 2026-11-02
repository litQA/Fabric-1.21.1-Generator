<#-- @formatter:off -->

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

import net.fabricmc.fabric.api.command.v2.CommandRegistrationCallback;

public class ${JavaModName}Commands {

	public static void load() {
		CommandRegistrationCallback.EVENT.register((dispatcher, commandBuildContext, environment) -> {
		<#list commands as command>
			<#if command.type == "CLIENTSIDE">
			// Client side commands are registered on the integrated server dispatcher on Fabric, see MIGRATION-REPORT.md
			if (environment.includeIntegrated)
				${command.getModElement().getName()}Command.register(dispatcher, commandBuildContext, environment);
			<#elseif command.type == "MULTIPLAYER_ONLY">
			if (environment == Commands.CommandSelection.DEDICATED)
				${command.getModElement().getName()}Command.register(dispatcher, commandBuildContext, environment);
			<#elseif command.type == "SINGLEPLAYER_ONLY">
			if (environment == Commands.CommandSelection.INTEGRATED)
				${command.getModElement().getName()}Command.register(dispatcher, commandBuildContext, environment);
			<#else>
			${command.getModElement().getName()}Command.register(dispatcher, commandBuildContext, environment);
			</#if>
		</#list>
		});
	}
}
<#-- @formatter:on -->
