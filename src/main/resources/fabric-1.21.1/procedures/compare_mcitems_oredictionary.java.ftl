<#include "mcelements.ftl">
<#include "mcitems.ftl">
(${mappedMCItemToItemStackCode(input$a, 1)}.is(net.minecraft.tags.TagKey.create(net.minecraft.core.registries.Registries.ITEM, ${toResourceLocation(input$b)})))