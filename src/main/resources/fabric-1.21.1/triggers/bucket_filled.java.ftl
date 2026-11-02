<#include "procedures.java.ftl">
public class ${name}Procedure {

	static {
		net.fabricmc.fabric.api.event.player.UseItemCallback.EVENT.register((player, world, hand) -> {
			net.minecraft.world.item.ItemStack stack = player.getItemInHand(hand);
			if (!stack.is(net.minecraft.world.item.Items.BUCKET))
				return net.minecraft.world.InteractionResultHolder.pass(stack);
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "player.getX()",
					"y": "player.getY()",
					"z": "player.getZ()",
					"world": "world",
					"itemstack": "stack",
					"entity": "player"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
			return net.minecraft.world.InteractionResultHolder.pass(stack);
		});
	}

	public ${name}Procedure() {
	}
