<#include "mcelements.ftl">
<@addTemplate file="utils/block_inventory/get_item.java.ftl"/>
<@addTemplate file="utils/block_inventory/set_item.java.ftl"/>
<#-- @formatter:off -->
if (world instanceof ServerLevel _serverLevel) {
	ItemStack _stk = itemFromBlockInventory(world, ${toBlockPos(input$x,input$y,input$z)}, ${opt.toInt(input$slotid)}).copy();
	_stk.hurtAndBreak(${opt.toInt(input$amount)}, _serverLevel, null, _item -> {});
	setBlockInventoryItem(world, ${toBlockPos(input$x,input$y,input$z)}, ${opt.toInt(input$slotid)}, _stk);
}
<#-- @formatter:on -->
