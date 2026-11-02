private static double getEntitySubmergedHeight(Entity entity) {
	FluidState state = entity.level().getFluidState(entity.blockPosition());
	if (state.is(FluidTags.WATER))
		return entity.getFluidHeight(FluidTags.WATER);
	if (state.is(FluidTags.LAVA))
		return entity.getFluidHeight(FluidTags.LAVA);
	return 0;
}
