if (${input$entity} instanceof Player _playerIter) {
	for (int _idx = 0; _idx < _playerIter.getInventory().getContainerSize(); _idx++) {
		ItemStack itemstackiterator = _playerIter.getInventory().getItem(_idx).copy();
		${statement$foreach}
	}
}
