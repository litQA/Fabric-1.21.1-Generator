private static ItemStack extractFromBlockInventory(LevelAccessor world, BlockPos pos, int slot, int amount, boolean simulate) {
	if (world instanceof Level level && level.getBlockEntity(pos) instanceof Container container && slot >= 0 && slot < container.getContainerSize()) {
		ItemStack existing = container.getItem(slot);
		if (!existing.isEmpty()) {
			int taken = Math.min(amount, existing.getCount());
			ItemStack result = existing.copyWithCount(taken);
			if (!simulate) {
				existing.shrink(taken);
				container.setChanged();
			}
			return result;
		}
	}
	return ItemStack.EMPTY;
}
