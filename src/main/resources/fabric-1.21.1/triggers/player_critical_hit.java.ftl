<#include "procedures.java.ftl">
import ${package}.trigger.${JavaModName}Triggers;
public class ${name}Procedure {
	static {
		${JavaModName}Triggers.CRITICAL_HIT.add((player, target) -> {
			boolean critical = player.fallDistance > 0.0F && !player.onGround() && !player.onClimbable()
					&& !player.isInWater() && !player.isPassenger()
					&& !player.hasEffect(net.minecraft.world.effect.MobEffects.BLINDNESS);
			<#assign dependenciesCode>
				<@procedureDependenciesCode dependencies, {
					"x": "player.getX()", "y": "player.getY()", "z": "player.getZ()",
					"world": "player.level()", "entity": "target", "sourceentity": "player",
					"damagemodifier": "critical ? 1.5f : 1.0f", "isvanillacritical": "critical"
				}/>
			</#assign>
			execute(<#if dependenciesCode?has_content>${dependenciesCode}</#if>);
			return true;
		});
	}
	public ${name}Procedure() {
	}
