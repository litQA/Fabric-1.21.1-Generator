<#-- @formatter:off -->
<#include "../mcitems.ftl">

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

import net.fabricmc.fabric.api.object.builder.v1.world.poi.PointOfInterestHelper;

public class ${JavaModName}VillagerProfessions {

	private static final Map<String, Holder<PoiType>> POI_TYPES = new HashMap<>();

	<#list villagerprofessions as villagerprofession>
	public static VillagerProfession ${villagerprofession.getModElement().getRegistryNameUpper()};
	</#list>

	public static void load() {
		<#list villagerprofessions as villagerprofession>
		${villagerprofession.getModElement().getRegistryNameUpper()} =
			registerProfession("${villagerprofession.getModElement().getRegistryName()}",
				() -> ${mappedBlockToBlock(villagerprofession.pointOfInterest)},
				() -> BuiltInRegistries.SOUND_EVENT.get(ResourceLocation.parse("${villagerprofession.actionSound}")));
		</#list>
	}

	private static VillagerProfession registerProfession(String name, Supplier<Block> block, Supplier<SoundEvent> soundEvent) {
		PoiType poiType = PointOfInterestHelper.register(ResourceLocation.fromNamespaceAndPath(${JavaModName}.MODID, name + "_poi"), 1, 1, block.get());
		Holder<PoiType> poiTypeHolder = BuiltInRegistries.POINT_OF_INTEREST_TYPE.wrapAsHolder(poiType);
		POI_TYPES.put(name, poiTypeHolder);

		Predicate<Holder<PoiType>> poiPredicate = holder -> holder.value() == poiType;

		return Registry.register(BuiltInRegistries.VILLAGER_PROFESSION, ResourceLocation.fromNamespaceAndPath(${JavaModName}.MODID, name),
			new VillagerProfession("${modid}." + name, poiPredicate, poiPredicate, ImmutableSet.of(), ImmutableSet.of(), soundEvent.get()));
	}
}
<#-- @formatter:on -->
