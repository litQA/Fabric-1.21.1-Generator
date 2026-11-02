<#include "mcitems.ftl">
if (${input$entity} instanceof Player _playerSlot)
	_playerSlot.getInventory().setItem(${opt.toInt(input$slotid)}, ${mappedMCItemToItemStackCode(input$item, 1)}.copy());

