<#include "mcelements.ftl">
<#include "mcitems.ftl">
<@addTemplate file="utils/block_inventory/set_item.java.ftl"/>
<#-- @formatter:off -->
ItemStack _setstack = ${mappedMCItemToItemStackCode(input$item, 1)}.copy();
_setstack.setCount(${opt.toInt(input$amount)});
setBlockInventoryItem(world, ${toBlockPos(input$x,input$y,input$z)}, ${opt.toInt(input$slotid)}, _setstack);
<#-- @formatter:on -->
