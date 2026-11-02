<#-- @formatter:off -->
package ${package}.mixin;

import com.mojang.brigadier.ParseResults;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

import net.minecraft.commands.CommandSourceStack;
import net.minecraft.commands.Commands;

@Mixin(Commands.class)
public class CommandManagerMixin {

	@Inject(method = "performCommand", at = @At("HEAD"))
	private void onCommand(ParseResults<CommandSourceStack> parse, String command, CallbackInfo callback) {
		${JavaModName}Triggers.fireCommand(parse.getContext().getSource(), command, parse.getContext().build(command));
	}
}
<#-- @formatter:on -->
