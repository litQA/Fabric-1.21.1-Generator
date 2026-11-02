<#include "mcelements.ftl">
/*@float*/(world.getBlockState(${toBlockPos(input$x,input$y,input$z)}).is(net.minecraft.tags.BlockTags.ENCHANTMENT_POWER_PROVIDER) ? 1.0f : 0.0f /* Fabric: vanilla enchanting power providers only, see MIGRATION-REPORT.md */)
