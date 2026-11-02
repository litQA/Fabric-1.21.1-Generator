private static int getBlockInventorySlotCount(LevelAccessor world, BlockPos pos) {
	if (world instanceof Level level && level.getBlockEntity(pos) instanceof Container container)
		return container.getContainerSize();
	return 0;
}
