<#-- @formatter:off -->
<#include "procedures.java.ftl">

package ${package}.command;

public class ${name}Command {

	public static void register(CommandDispatcher<CommandSourceStack> dispatcher, CommandBuildContext commandBuildContext, Commands.CommandSelection environment) {
		dispatcher.register(Commands.literal("${data.commandName}")
			<#if data.permissionLevel != "No requirement">.requires(s -> s.hasPermission(${data.permissionLevel}))</#if>
			${argscode}
		);
	}

	${extra_templates_code}
}
<#-- @formatter:on -->
