<#-- @formatter:off -->
package ${package};

import java.util.Comparator;
import java.util.PriorityQueue;
import java.util.Queue;
import java.util.concurrent.ConcurrentLinkedQueue;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import net.fabricmc.api.ModInitializer;
import net.fabricmc.fabric.api.event.lifecycle.v1.ServerTickEvents;

public class ${JavaModName} implements ModInitializer {

	public static final Logger LOGGER = LogManager.getLogger(${JavaModName}.class);

	public static final String MODID = "${modid}";

	@Override public void onInitialize() {
		// Start of user code block mod constructor
		// End of user code block mod constructor

		LOGGER.info("Initializing ${JavaModName}");

		<@javacompress>
		<#if w.hasSounds()>${JavaModName}Sounds.load();</#if>
		<#if w.hasVariables()>${JavaModName}Variables.load();</#if>
		<#if w.getGElementsOfType('fluid')?size != 0>${JavaModName}Fluids.load();</#if>
		<#if types.base_blocks?has_content>${JavaModName}Blocks.load();</#if>
		<#if types.base_blockentities?has_content>${JavaModName}BlockEntities.load();</#if>
		<#if types.base_entities?has_content>${JavaModName}Entities.load();</#if>
		<#-- Armor materials must be registered before the armor items are constructed -->
		<#list w.getGElementsOfType('armor') as armor>
		${armor.getModElement().getName()}Item.load();
		</#list>
		<#if types.base_items?has_content>${JavaModName}Items.load();</#if>
		<#if w.hasItemsInTabs()>${JavaModName}Tabs.load();</#if>
		<#if w.getGElementsOfType('villagerprofession')?size != 0>${JavaModName}VillagerProfessions.load();</#if>
		<#if w.getGElementsOfType('villagertrade')?size != 0>${JavaModName}Trades.registerTrades();</#if>
		<#list w.getGElementsOfType('recipe')?filter(e -> e.recipeType == "Brewing") as recipe>
		${recipe.getModElement().getName()}BrewingRecipe.load();
		</#list>
		<#if w.hasElementsOfType('gui')>${JavaModName}Menus.load();</#if>
		<#if w.getGElementsOfType('feature')?size != 0>${JavaModName}Features.load();</#if>
		<#if w.getGElementsOfType('dimension')?size != 0>${JavaModName}Dimensions.load();</#if>
		<#if w.getGElementsOfType('itemextension')?size != 0>${JavaModName}ItemExtensions.load();</#if>
		<#if w.getGElementsOfType('itemextension')?filter(e -> e.hasDispenseBehavior)?size != 0>${JavaModName}DispenseBehaviors.load();</#if>
		<#if w.getGElementsOfType('biome')?filter(e -> e.hasVines() || e.hasFruits())?size != 0>${JavaModName}Biomes.load();</#if>
		<#if w.getGElementsOfType('biome')?filter(e -> e.spawnBiome || e.spawnInCaves || e.spawnBiomeNether)?size != 0>${JavaModName}Biomes.init();</#if>
		<#if types.attributes?has_content>${JavaModName}Attributes.load();</#if>
		<#if types.gamerules?has_content>${JavaModName}GameRules.load();</#if>
		<#if w.hasElementsOfType('particle')>${JavaModName}ParticleTypes.load();</#if>
		<#if w.hasElementsOfType('potioneffect')>${JavaModName}MobEffects.load();</#if>
		<#if w.hasElementsOfType('potion')>${JavaModName}Potions.load();</#if>
		<#if w.hasElementsOfType('command')>${JavaModName}Commands.load();</#if>
		</@javacompress>

		tick();

		<#-- Trigger handlers register themselves in static initializers, so every procedure class is loaded once -->
		<#list w.getGElementsOfType('procedure') as procedure>
		new ${package}.procedures.${procedure.getModElement().getName()}Procedure();
		</#list>

		// Start of user code block mod init
		// End of user code block mod init
	}

	// Start of user code block mod methods
	// End of user code block mod methods

	<#-- Wait procedure block support below, the delay is resolved against the server tick counter -->
	private record ScheduledTask(Runnable action, int delay) {}

	private record TickTask(int tick, Runnable action) {}

	private static final Queue<ScheduledTask> pendingTasks = new ConcurrentLinkedQueue<>();
	private static final PriorityQueue<TickTask> runningTasks = new PriorityQueue<>(Comparator.comparingInt(TickTask::tick));

	public static void queueServerWork(int delay, Runnable action) {
		pendingTasks.add(new ScheduledTask(action, delay));
	}

	private void tick() {
		ServerTickEvents.END_SERVER_TICK.register(server -> {
			int currentTick = server.getTickCount();

			ScheduledTask scheduled;
			while ((scheduled = pendingTasks.poll()) != null) {
				runningTasks.add(new TickTask(currentTick + scheduled.delay(), scheduled.action()));
			}

			while (!runningTasks.isEmpty() && currentTick >= runningTasks.peek().tick()) {
				runningTasks.poll().action().run();
			}
		});
	}

	// Start of user code block mod static methods
	// End of user code block mod static methods
}
<#-- @formatter:on -->


















