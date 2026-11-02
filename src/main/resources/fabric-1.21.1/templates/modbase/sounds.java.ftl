<#-- @formatter:off -->

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

public class ${JavaModName}Sounds {

	<#list sounds as sound>
	public static SoundEvent ${sound.getJavaName()};
	</#list>

	public static void load() {
		<#list sounds as sound>
		${sound.getJavaName()} = register("${sound.getName()}", SoundEvent.createVariableRangeEvent(ResourceLocation.fromNamespaceAndPath("${modid}", "${sound}")));
		</#list>
	}

	private static SoundEvent register(String registryname, SoundEvent element) {
		return Registry.register(BuiltInRegistries.SOUND_EVENT, ResourceLocation.fromNamespaceAndPath(${JavaModName}.MODID, registryname), element);
	}
}
<#-- @formatter:on -->
