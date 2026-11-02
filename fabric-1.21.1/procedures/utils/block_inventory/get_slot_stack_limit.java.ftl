private static int getBlockInventorySlotStackLimit(LevelAccessor world, BlockPos pos, int slot) {
	if (world instanceof Level level && level.getBlockEntity(pos) instanceof Container container && slot >= 0 && slot < container.getContainerSize())
		return Math.min(container.getMaxStackSize(), container.getItem(slot).getMaxStackSize());
	return 0;
}

