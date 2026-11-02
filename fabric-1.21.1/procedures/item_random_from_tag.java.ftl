<#include "mcelements.ftl">
(BuiltInRegistries.ITEM.getOrCreateTag(net.minecraft.tags.TagKey.create(net.minecraft.core.registries.Registries.ITEM, ${toResourceLocation(input$tag)})).getRandomElement(RandomSource.create())
		.orElseGet(() -> BuiltInRegistries.ITEM.wrapAsHolder(Items.AIR)).value())