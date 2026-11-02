<#-- @formatter:off -->
<#include "../mcitems.ftl">

<#macro trades entries level villagerProfession>
<#if entries?has_content>
	<#if villagerProfession == "WanderingTrader">
	TradeOfferHelper.registerWanderingTraderOffers(${level} == 1 ? 1 : 2, factories -> {
		<#list entries as entry>
		factories.add(<@basicTrade entry/>);
		</#list>
	});
	<#else>
	TradeOfferHelper.registerVillagerOffers(${villagerProfession?string?replace(".get()", "")}, ${level}, factories -> {
		<#list entries as entry>
		factories.add(<@basicTrade entry/>);
		</#list>
	});
	</#if>
</#if>
</#macro>

<#macro basicTrade entry>
new BasicTrade(${mappedMCItemToItemStackCode(entry.price1, entry.countPrice1)},
	<#if entry.price2?has_content && !entry.price2.isEmpty()>${mappedMCItemToItemStackCode(entry.price2, entry.countPrice2)}<#else>ItemStack.EMPTY</#if>,
	${mappedMCItemToItemStackCode(entry.offer, entry.countOffer)}, ${entry.maxTrades}, ${entry.xp}, ${entry.priceMultiplier}f)
</#macro>

<@javacompress>

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

import net.fabricmc.fabric.api.object.builder.v1.trade.TradeOfferHelper;

import net.minecraft.util.RandomSource;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.npc.VillagerTrades;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.trading.ItemCost;
import net.minecraft.world.item.trading.MerchantOffer;

import org.jetbrains.annotations.NotNull;

import java.util.Optional;

public class ${JavaModName}Trades {

	public static void registerTrades() {
		<#list villagertrades as trade>
		<#assign lv1 = []>
		<#assign lv2 = []>
		<#assign lv3 = []>
		<#assign lv4 = []>
		<#assign lv5 = []>

		<#list trade.trades as entry>
			<#if entry.level == 1><#assign lv1 = lv1 + [entry]>
			<#elseif entry.level == 2><#assign lv2 = lv2 + [entry]>
			<#elseif entry.level == 3><#assign lv3 = lv3 + [entry]>
			<#elseif entry.level == 4><#assign lv4 = lv4 + [entry]>
			<#elseif entry.level == 5><#assign lv5 = lv5 + [entry]>
			</#if>
		</#list>

		<@trades lv1, 1, trade.villagerProfession/>
		<@trades lv2, 2, trade.villagerProfession/>
		<@trades lv3, 3, trade.villagerProfession/>
		<@trades lv4, 4, trade.villagerProfession/>
		<@trades lv5, 5, trade.villagerProfession/>
		</#list>
	}

	private record BasicTrade(ItemStack price, ItemStack price2, ItemStack offer, int maxTrades, int xp, float priceMult) implements VillagerTrades.ItemListing {
		@Override public @NotNull MerchantOffer getOffer(Entity entity, RandomSource random) {
			Optional<ItemCost> secondCost = price2.isEmpty() ? Optional.empty() : Optional.of(new ItemCost(price2.getItem(), price2.getCount()));
			return new MerchantOffer(new ItemCost(price.getItem(), price.getCount()), secondCost, offer, maxTrades, xp, priceMult);
		}
	}
}
</@javacompress>
<#-- @formatter:on -->

