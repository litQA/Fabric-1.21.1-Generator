<#include "mcelements.ftl">
<@addTemplate file="utils/block_inventory/set_item.java.ftl"/>
setBlockInventoryItem(world, ${toBlockPos(input$x,input$y,input$z)}, ${opt.toInt(input$slotid)}, ItemStack.EMPTY);
