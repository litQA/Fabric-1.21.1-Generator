<#-- @formatter:off -->
<#include "../mcitems.ftl">

package ${package}.world.teleporter;

public class ${name}Teleporter {

	public static Holder<PoiType> poi = null;

	public static void registerPointOfInterest() {
		PoiType poiType = new PoiType(ImmutableSet.copyOf(${JavaModName}Blocks.${REGISTRYNAME}_PORTAL.getStateDefinition().getPossibleStates()), 0, 1);
		poi = Registry.registerForHolder(BuiltInRegistries.POINT_OF_INTEREST_TYPE, ResourceLocation.parse("${modid}:${registryname}_portal"), poiType);
	}

	private final ServerLevel level;

	public ${name}Teleporter(ServerLevel level) {
		this.level = level;
	}

	${mcc.getMethod("net.minecraft.world.level.portal.PortalForcer", "findClosestPortalPosition", "BlockPos", "boolean", "WorldBorder")
		 .replace("PoiTypes.NETHER_PORTAL", "poi.unwrapKey().get()")
		 .replace("Comparator.comparingDouble(blockPos2 -> blockPos2.distSqr(blockPos3)).thenComparingInt(Vec3i::getY)", "Comparator.comparingDouble((BlockPos blockPos2) -> blockPos2.distSqr(blockPos3)).thenComparingInt((BlockPos blockPos4) -> blockPos4.getY())")}

	${mcc.getMethod("net.minecraft.world.level.portal.PortalForcer", "createPortal", "BlockPos", "Direction.Axis")
		 .replace("Blocks.OBSIDIAN", mappedBlockToBlock(data.portalFrame)?string)
		 .replace(",blockstate,18);", ", blockstate, 18);\nthis.level.getPoiManager().add(blockpos$mutableblockpos, poi);")
		 .replace("Blocks.NETHER_PORTAL", JavaModName + "Blocks." + REGISTRYNAME + "_PORTAL")}

	${mcc.getMethod("net.minecraft.world.level.portal.PortalForcer", "canHostFrame", "BlockPos", "BlockPos.MutableBlockPos", "Direction", "int")}

	private boolean canPortalReplaceBlock(BlockPos.MutableBlockPos pos) {
		BlockState blockstate = this.level.getBlockState(pos);
		return blockstate.canBeReplaced() && blockstate.getFluidState().isEmpty();
	}

}
<#-- @formatter:on -->

