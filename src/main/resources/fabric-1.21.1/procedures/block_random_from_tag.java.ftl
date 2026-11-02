<#include "mcelements.ftl">
(BuiltInRegistries.BLOCK.getOrCreateTag(net.minecraft.tags.TagKey.create(net.minecraft.core.registries.Registries.BLOCK, ${toResourceLocation(input$tag)})).getRandomElement(RandomSource.create())
	.orElseGet(() -> BuiltInRegistries.BLOCK.wrapAsHolder(Blocks.AIR)).value())