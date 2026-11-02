private static void setBlockInventoryItem(LevelAccessor world, BlockPos pos, int slot, ItemStack stack) {
	if (world instanceof Level level && level.getBlockEntity(pos) instanceof Container container) {
		if (slot >= 0 && slot < container.getContainerSize()) {
			container.setItem(slot, stack);
			container.setChanged();
		}
	}
}
