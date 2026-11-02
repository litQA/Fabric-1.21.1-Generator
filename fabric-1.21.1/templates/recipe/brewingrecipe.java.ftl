<#-- @formatter:off -->
<#include "../mcitems.ftl">

package ${package}.recipe.brewing;

import net.fabricmc.fabric.api.registry.FabricBrewingRecipeRegistryBuilder;

public class ${name}BrewingRecipe {

	public static void load() {
		<#if data.brewingInputStack?starts_with("POTION:") && data.brewingReturnStack?starts_with("POTION:")>
		FabricBrewingRecipeRegistryBuilder.BUILD.register(builder -> {
			builder.registerPotionRecipe(${generator.map(data.brewingInputStack?replace("POTION:",""), "potions")},
					${mappedMCItemToIngredient(data.brewingIngredientStack)},
					${generator.map(data.brewingReturnStack?replace("POTION:",""), "potions")});
		});
		<#else>
		// Brewing recipes that transform arbitrary items are not supported on 1.21.1, see MIGRATION-REPORT.md
		</#if>
	}
}
<#-- @formatter:on -->
