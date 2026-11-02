private static boolean canInsertIntoBlockInventory(LevelAccessor world, BlockPos pos, int slot, ItemStack stack) {
	if (world instanceof Level level && level.getBlockEntity(pos) instanceof Container container && slot >= 0 && slot < container.getContainerSize())
		return container.canPlaceItem(slot, stack);
	return false;
}
