private static int insertInBlockInventory(LevelAccessor world, BlockPos pos, int slot, int amount, ItemStack itemstack, boolean simulate) {
	if (world instanceof Level level && level.getBlockEntity(pos) instanceof Container container && slot >= 0 && slot < container.getContainerSize()) {
		ItemStack existing = container.getItem(slot);
		int limit = Math.min(container.getMaxStackSize(), itemstack.getMaxStackSize());
		if (existing.isEmpty()) {
			int moved = Math.min(amount, limit);
			if (!simulate) {
				container.setItem(slot, itemstack.copyWithCount(moved));
				container.setChanged();
			}
			return amount - moved;
		}
		if (ItemStack.isSameItemSameComponents(existing, itemstack)) {
			int moved = Math.min(amount, limit - existing.getCount());
			if (!simulate) {
				existing.grow(moved);
				container.setChanged();
			}
			return amount - moved;
		}
	}
	return amount;
}
