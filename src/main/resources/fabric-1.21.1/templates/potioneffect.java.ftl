<#-- @formatter:off -->
<#include "procedures.java.ftl">

package ${package}.potion;

<@javacompress>
public class ${name}MobEffect extends <#if data.isInstant>Instantenous</#if>MobEffect {

	public ${name}MobEffect() {
		super(MobEffectCategory.${data.mobEffectCategory}, ${data.color.getRGB()});
		<#if data.onAddedSound?has_content && data.onAddedSound.getMappedValue()?has_content>
		this.withSoundOnAdded(BuiltInRegistries.SOUND_EVENT.get(ResourceLocation.parse("${data.onAddedSound}")));
		</#if>
		<#list data.modifiers as modifier>
		this.addAttributeModifier(${modifier.attribute},
				ResourceLocation.fromNamespaceAndPath(${JavaModName}.MODID, "effect.${registryname}_${modifier?index}"),
				${modifier.amount}, AttributeModifier.Operation.${modifier.operation});
		</#list>
	}

	<#if data.hasCustomParticle()>
	@Override public ParticleOptions createParticleOptions(MobEffectInstance mobEffectInstance) {
		return ${data.particle};
	}
	</#if>

	<#-- Honey based cures are a NeoForge extension and are not available on Fabric, see MIGRATION-REPORT.md -->

	<#if hasProcedure(data.onStarted)>
		<#if data.isInstant>
			@Override public void applyInstantenousEffect(Entity source, Entity indirectSource, LivingEntity entity, int amplifier, double health) {
				<@procedureCode data.onStarted, {
					"x": "entity.getX()",
					"y": "entity.getY()",
					"z": "entity.getZ()",
					"world": "entity.level()",
					"entity": "entity",
					"amplifier": "amplifier"
				}/>
			}
		<#else>
			@Override public void onEffectStarted(LivingEntity entity, int amplifier) {
				<@procedureCode data.onStarted, {
					"x": "entity.getX()",
					"y": "entity.getY()",
					"z": "entity.getZ()",
					"world": "entity.level()",
					"entity": "entity",
					"amplifier": "amplifier"
				}/>
			}
		</#if>
	</#if>

	<#if hasProcedure(data.activeTickCondition) || hasProcedure(data.onActiveTick)>
		@Override public boolean shouldApplyEffectTickThisTick(int duration, int amplifier) {
			<#if hasProcedure(data.activeTickCondition)>
				return <@procedureOBJToConditionCode data.activeTickCondition/>;
			<#else>
				return true;
			</#if>
		}
	</#if>

	<#if hasProcedure(data.onActiveTick)>
		@Override public boolean applyEffectTick(LivingEntity entity, int amplifier) {
			<@procedureCode data.onActiveTick, {
				"x": "entity.getX()",
				"y": "entity.getY()",
				"z": "entity.getZ()",
				"world": "entity.level()",
				"entity": "entity",
				"amplifier": "amplifier"
			}/>
			return super.applyEffectTick(entity, amplifier);
		}
	</#if>

	<#if hasProcedure(data.onMobHurt)>
		@Override public void onMobHurt(LivingEntity entity, int amplifier, DamageSource damagesource, float damage) {
			<@procedureCode data.onMobHurt, {
				"x": "entity.getX()",
				"y": "entity.getY()",
				"z": "entity.getZ()",
				"world": "entity.level()",
				"entity": "entity",
				"amplifier": "amplifier",
				"damagesource": "damagesource",
				"amount": "damage"
			}/>
		}
	</#if>

	<#if hasProcedure(data.onMobRemoved)>
		@Override public void onMobRemoved(LivingEntity entity, int amplifier, Entity.RemovalReason reason) {
			if (reason == Entity.RemovalReason.KILLED) {
				<@procedureCode data.onMobRemoved, {
					"x": "entity.getX()",
					"y": "entity.getY()",
					"z": "entity.getZ()",
					"world": "entity.level()",
					"entity": "entity",
					"amplifier": "amplifier"
				}/>
			}
		}
	</#if>

	<#-- Custom effect renderer visibility is a NeoForge extension, vanilla renders the effect icon from its data asset, see MIGRATION-REPORT.md -->
}
</@javacompress>
<#-- @formatter:on -->
