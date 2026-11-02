private static ItemStack itemFromBlockInventory(LevelAccessor world, BlockPos pos, int slot) {
	if (world instanceof Level level && level.getBlockEntity(pos) instanceof Container container) {
		if (slot >= 0 && slot < container.getContainerSize())
			return container.getItem(slot);
	}
	return ItemStack.EMPTY;
}
