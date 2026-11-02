<#-- @formatter:off -->

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

import net.fabricmc.api.EnvType;
import net.fabricmc.api.Environment;
import net.fabricmc.fabric.api.client.rendering.v1.HudRenderCallback;
import net.fabricmc.fabric.api.client.screen.v1.ScreenEvents;

@Environment(EnvType.CLIENT) public class ${JavaModName}Overlays {

	public static void clientLoad() {
		<#list overlays as overlay>
			<#if overlay.overlayTarget == "Ingame">
		HudRenderCallback.EVENT.register((guiGraphics, deltaTracker) -> ${overlay.getModElement().getName()}Overlay.render(guiGraphics));
			<#else>
		ScreenEvents.AFTER_INIT.register((client, screen, scaledWidth, scaledHeight) -> {
			if (screen instanceof ${overlay.overlayTarget})
				ScreenEvents.afterRender(screen).register((s, guiGraphics, mouseX, mouseY, tickDelta) -> ${overlay.getModElement().getName()}Overlay.render(guiGraphics));
		});
			</#if>
		</#list>
	}
}
<#-- @formatter:on -->
