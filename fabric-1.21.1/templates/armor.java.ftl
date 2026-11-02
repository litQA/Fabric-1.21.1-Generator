<#-- @formatter:off -->
<#include "mcitems.ftl">

package ${package}.item;

import net.minecraft.Util;
import net.minecraft.core.Holder;
import net.minecraft.core.Registry;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.sounds.SoundEvents;
import net.minecraft.world.item.ArmorItem;
import net.minecraft.world.item.ArmorMaterial;
import net.minecraft.world.item.Item;
import net.minecraft.world.item.crafting.Ingredient;

import java.util.EnumMap;
import java.util.List;
<@javacompress>
public abstract class ${name}Item extends ArmorItem {

	public static Holder<ArmorMaterial> ARMOR_MATERIAL = null;

	public static void load() {
		ArmorMaterial armorMaterial = new ArmorMaterial(
			Util.make(new EnumMap<>(ArmorItem.Type.class), map -> {
				map.put(ArmorItem.Type.BOOTS, ${data.damageValueBoots});
				map.put(ArmorItem.Type.LEGGINGS, ${data.damageValueLeggings});
				map.put(ArmorItem.Type.CHESTPLATE, ${data.damageValueBody});
				map.put(ArmorItem.Type.HELMET, ${data.damageValueHelmet});
				map.put(ArmorItem.Type.BODY, ${data.damageValueBody});
			}),
			${data.enchantability},
			<#if data.equipSound?has_content && data.equipSound.getUnmappedValue()?has_content>
			BuiltInRegistries.SOUND_EVENT.wrapAsHolder(BuiltInRegistries.SOUND_EVENT.get(ResourceLocation.parse("${data.equipSound}"))),
			<#else>
			BuiltInRegistries.SOUND_EVENT.wrapAsHolder(SoundEvents.EMPTY),
			</#if>
			() -> ${mappedMCItemsToIngredient(data.repairItems)},
			List.of(new ArmorMaterial.Layer(ResourceLocation.parse("${modid}:${data.armorTextureFile}"))),
			${data.toughness}f,
			${data.knockbackResistance}f
		);
		ARMOR_MATERIAL = Registry.registerForHolder(BuiltInRegistries.ARMOR_MATERIAL, ResourceLocation.fromNamespaceAndPath(${JavaModName}.MODID, "${registryname}"), armorMaterial);
	}

	protected ${name}Item(ArmorItem.Type type, Item.Properties properties) {
		super(ARMOR_MATERIAL, type, properties);
	}

	<#if data.enableHelmet>
	public static class Helmet extends ${name}Item {
		public Helmet() {
			super(ArmorItem.Type.HELMET, new Item.Properties()<#if data.maxDamage != 0>.durability(ArmorItem.Type.HELMET.getDurability(${data.maxDamage}))<#else>.stacksTo(1)</#if><#if data.helmetImmuneToFire>.fireResistant()</#if>);
		}
	}
	</#if>

	<#if data.enableBody>
	public static class Body extends ${name}Item {
		public Body() {
			super(ArmorItem.Type.CHESTPLATE, new Item.Properties()<#if data.maxDamage != 0>.durability(ArmorItem.Type.CHESTPLATE.getDurability(${data.maxDamage}))<#else>.stacksTo(1)</#if><#if data.bodyImmuneToFire>.fireResistant()</#if>);
		}
	}
	</#if>

	<#if data.enableLeggings>
	public static class Leggings extends ${name}Item {
		public Leggings() {
			super(ArmorItem.Type.LEGGINGS, new Item.Properties()<#if data.maxDamage != 0>.durability(ArmorItem.Type.LEGGINGS.getDurability(${data.maxDamage}))<#else>.stacksTo(1)</#if><#if data.leggingsImmuneToFire>.fireResistant()</#if>);
		}
	}
	</#if>

	<#if data.enableBoots>
	public static class Boots extends ${name}Item {
		public Boots() {
			super(ArmorItem.Type.BOOTS, new Item.Properties()<#if data.maxDamage != 0>.durability(ArmorItem.Type.BOOTS.getDurability(${data.maxDamage}))<#else>.stacksTo(1)</#if><#if data.bootsImmuneToFire>.fireResistant()</#if>);
		}
	}
	</#if>
}
</@javacompress>
<#-- @formatter:on -->



