<#-- @formatter:off -->
package ${package}.network;

import ${package}.${JavaModName};

import net.fabricmc.api.EnvType;
import net.fabricmc.api.Environment;
import net.fabricmc.fabric.api.attachment.v1.AttachmentRegistry;
import net.fabricmc.fabric.api.attachment.v1.AttachmentType;
import net.fabricmc.fabric.api.networking.v1.PayloadTypeRegistry;
import net.fabricmc.fabric.api.networking.v1.ServerPlayConnectionEvents;
import net.fabricmc.fabric.api.networking.v1.ServerPlayNetworking;
import net.fabricmc.fabric.api.client.networking.v1.ClientPlayNetworking;

import net.minecraft.client.Minecraft;
import net.minecraft.core.HolderLookup;
import net.minecraft.nbt.CompoundTag;
import net.minecraft.network.RegistryFriendlyByteBuf;
import net.minecraft.network.codec.StreamCodec;
import net.minecraft.network.protocol.common.custom.CustomPacketPayload;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.world.level.Level;
import net.minecraft.world.level.LevelAccessor;
import net.minecraft.world.level.saveddata.SavedData;
import net.minecraft.util.datafix.DataFixTypes;

public class ${JavaModName}Variables {

	<#-- PLAYER_LIFETIME and PLAYER_PERSISTENT variables are stored per player through a Fabric data attachment -->
	<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
	public static final AttachmentType<CompoundTag> PLAYER_VARIABLES = AttachmentRegistry.createPersistent(
			ResourceLocation.fromNamespaceAndPath(${JavaModName}.MODID, "player_variables"), CompoundTag.CODEC);

	private static final java.util.Map<java.util.UUID, PlayerVariables> PLAYER_CACHE = new java.util.concurrent.ConcurrentHashMap<>();

	public static PlayerVariables playerVars(net.minecraft.world.entity.Entity entity) {
		if (!(entity instanceof net.minecraft.world.entity.player.Player player))
			return new PlayerVariables();
		java.util.UUID id = player.getUUID();
		if (player.level() instanceof ServerLevel) {
			CompoundTag tag = player.getAttachedOrCreate(PLAYER_VARIABLES, CompoundTag::new);
			PlayerVariables vars = new PlayerVariables();
			vars.deserializeNBT(player.registryAccess(), tag);
			PLAYER_CACHE.put(id, vars);
			return vars;
		}
		return PLAYER_CACHE.computeIfAbsent(id, key -> new PlayerVariables());
	}

	public static void markPlayerDirty(net.minecraft.world.entity.Entity entity) {
		if (entity instanceof net.minecraft.world.entity.player.Player player) {
			PlayerVariables vars = PLAYER_CACHE.get(player.getUUID());
			if (vars != null) {
				CompoundTag tag = vars.serializeNBT(player.registryAccess());
				player.setAttached(PLAYER_VARIABLES, tag);
				if (player instanceof ServerPlayer serverPlayer)
					ServerPlayNetworking.send(serverPlayer, new SavedDataSyncMessage(2, tag));
			}
		}
	}
	</#if>

	<#-- GLOBAL_SESSION variables are kept in memory on each side; they are never persisted and never synchronised -->
	<#if w.hasVariablesOfScope("GLOBAL_SESSION")>
	<#list variables as var>
		<#if var.getScope().name() == "GLOBAL_SESSION">
			<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_SESSION")['init']?interpret/>
		</#if>
	</#list>
	</#if>

	public static void load() {
		<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP") || w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
		PayloadTypeRegistry.playS2C().register(SavedDataSyncMessage.TYPE, SavedDataSyncMessage.STREAM_CODEC);
		</#if>
		<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
		net.fabricmc.fabric.api.event.lifecycle.v1.ServerTickEvents.END_SERVER_TICK.register(${JavaModName}Variables::tick);
		</#if>
		<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
		ServerPlayConnectionEvents.JOIN.register((handler, sender, server) -> {
			ServerPlayer player = handler.getPlayer();
			PlayerVariables vars = new PlayerVariables();
			vars.deserializeNBT(player.registryAccess(), player.getAttachedOrCreate(PLAYER_VARIABLES, CompoundTag::new));
			PLAYER_CACHE.put(player.getUUID(), vars);
			ServerPlayNetworking.send(player, new SavedDataSyncMessage(2, vars.serializeNBT(player.registryAccess())));
		});
		</#if>
	}

	@Environment(EnvType.CLIENT) public static void loadClient() {
		<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP") || w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
		ClientPlayNetworking.registerGlobalReceiver(SavedDataSyncMessage.TYPE, (payload, context) -> SavedDataSyncMessage.handleData(payload, context.client()));
		</#if>
	}

	<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
	private static void tick(net.minecraft.server.MinecraftServer server) {
		for (ServerLevel level : server.getAllLevels()) {
			<#if w.hasVariablesOfScope("GLOBAL_WORLD")>
			WorldVariables worldVariables = WorldVariables.get(level);
			if (worldVariables._syncDirty) {
				for (ServerPlayer player : level.players())
					ServerPlayNetworking.send(player, new SavedDataSyncMessage(1, worldVariables.save(new CompoundTag(), player.registryAccess())));
				worldVariables._syncDirty = false;
			}
			</#if>
			<#if w.hasVariablesOfScope("GLOBAL_MAP")>
			MapVariables mapVariables = MapVariables.get(level);
			if (mapVariables._syncDirty && level.dimension() == Level.OVERWORLD) {
				for (ServerPlayer player : server.getPlayerList().getPlayers())
					ServerPlayNetworking.send(player, new SavedDataSyncMessage(0, mapVariables.save(new CompoundTag(), player.registryAccess())));
				mapVariables._syncDirty = false;
			}
			</#if>
		}
	}

	public static void syncPlayer(ServerPlayer player) {
		<#if w.hasVariablesOfScope("GLOBAL_MAP")>
		ServerPlayNetworking.send(player, new SavedDataSyncMessage(0, MapVariables.get(player.level()).save(new CompoundTag(), player.registryAccess())));
		</#if>
		<#if w.hasVariablesOfScope("GLOBAL_WORLD")>
		ServerPlayNetworking.send(player, new SavedDataSyncMessage(1, WorldVariables.get(player.level()).save(new CompoundTag(), player.registryAccess())));
		</#if>
	}
	</#if>

	<#if w.hasVariablesOfScope("GLOBAL_WORLD")>
	public static class WorldVariables extends SavedData {

		public static final String DATA_NAME = "${modid}_worldvars";

		boolean _syncDirty = false;

		<#list variables as var>
			<#if var.getScope().name() == "GLOBAL_WORLD">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_WORLD")['init']?interpret/>
			</#if>
		</#list>

		public static WorldVariables load(CompoundTag tag, HolderLookup.Provider lookupProvider) {
			WorldVariables data = new WorldVariables();
			data.read(tag, lookupProvider);
			return data;
		}

		public void read(CompoundTag nbt, HolderLookup.Provider lookupProvider) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_WORLD">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_WORLD")['read']?interpret/>
				</#if>
			</#list>
		}

		@Override public CompoundTag save(CompoundTag nbt, HolderLookup.Provider lookupProvider) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_WORLD">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_WORLD")['write']?interpret/>
				</#if>
			</#list>
			return nbt;
		}

		public void markSyncDirty() {
			this.setDirty();
			this._syncDirty = true;
		}

		static WorldVariables clientSide = new WorldVariables();

		public static WorldVariables get(LevelAccessor world) {
			if (world instanceof ServerLevel level) {
				return level.getDataStorage().computeIfAbsent(new SavedData.Factory<>(WorldVariables::new, WorldVariables::load, DataFixTypes.LEVEL), DATA_NAME);
			} else {
				return clientSide;
			}
		}
	}
	</#if>

	<#if w.hasVariablesOfScope("GLOBAL_MAP")>
	public static class MapVariables extends SavedData {

		public static final String DATA_NAME = "${modid}_mapvars";

		boolean _syncDirty = false;

		<#list variables as var>
			<#if var.getScope().name() == "GLOBAL_MAP">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_MAP")['init']?interpret/>
			</#if>
		</#list>

		public static MapVariables load(CompoundTag tag, HolderLookup.Provider lookupProvider) {
			MapVariables data = new MapVariables();
			data.read(tag, lookupProvider);
			return data;
		}

		public void read(CompoundTag nbt, HolderLookup.Provider lookupProvider) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_MAP">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_MAP")['read']?interpret/>
				</#if>
			</#list>
		}

		@Override public CompoundTag save(CompoundTag nbt, HolderLookup.Provider lookupProvider) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_MAP">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_MAP")['write']?interpret/>
				</#if>
			</#list>
			return nbt;
		}

		public void markSyncDirty() {
			this.setDirty();
			_syncDirty = true;
		}

		static MapVariables clientSide = new MapVariables();

		public static MapVariables get(LevelAccessor world) {
			if (world instanceof ServerLevel level) {
				ServerLevel overworld = level.getServer().getLevel(Level.OVERWORLD);
				return (overworld != null ? overworld : level).getDataStorage().computeIfAbsent(new SavedData.Factory<>(MapVariables::new, MapVariables::load, DataFixTypes.LEVEL), DATA_NAME);
			} else {
				return clientSide;
			}
		}
	}
	</#if>

	<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
	public static class PlayerVariables {

		<#list variables as var>
			<#if var.getScope().name() == "PLAYER_LIFETIME">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_LIFETIME")['init']?interpret/>
			<#elseif var.getScope().name() == "PLAYER_PERSISTENT">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_PERSISTENT")['init']?interpret/>
			</#if>
		</#list>

		public CompoundTag serializeNBT(HolderLookup.Provider lookupProvider) {
			CompoundTag nbt = new CompoundTag();
			<#list variables as var>
				<#if var.getScope().name() == "PLAYER_LIFETIME">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_LIFETIME")['write']?interpret/>
				<#elseif var.getScope().name() == "PLAYER_PERSISTENT">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_PERSISTENT")['write']?interpret/>
				</#if>
			</#list>
			return nbt;
		}

		public void deserializeNBT(HolderLookup.Provider lookupProvider, CompoundTag nbt) {
			<#list variables as var>
				<#if var.getScope().name() == "PLAYER_LIFETIME">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_LIFETIME")['read']?interpret/>
				<#elseif var.getScope().name() == "PLAYER_PERSISTENT">
					<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_PERSISTENT")['read']?interpret/>
				</#if>
			</#list>
		}
	}
	</#if>
	public record SavedDataSyncMessage(int dataType, CompoundTag data) implements CustomPacketPayload {

		public static final CustomPacketPayload.Type<SavedDataSyncMessage> TYPE = new CustomPacketPayload.Type<>(ResourceLocation.fromNamespaceAndPath(${JavaModName}.MODID, "saved_data_sync"));

		public static final StreamCodec<RegistryFriendlyByteBuf, SavedDataSyncMessage> STREAM_CODEC = new StreamCodec<>() {
			@Override public SavedDataSyncMessage decode(RegistryFriendlyByteBuf buffer) {
				return new SavedDataSyncMessage(buffer.readInt(), buffer.readNbt());
			}

			@Override public void encode(RegistryFriendlyByteBuf buffer, SavedDataSyncMessage message) {
				buffer.writeInt(message.dataType());
				buffer.writeNbt(message.data());
			}
		};

		@Override public CustomPacketPayload.Type<? extends CustomPacketPayload> type() {
			return TYPE;
		}

		@Environment(EnvType.CLIENT) public static void handleData(SavedDataSyncMessage message, Minecraft client) {
			client.execute(() -> {
				if (client.level == null || message.data() == null)
					return;
				<#if w.hasVariablesOfScope("GLOBAL_MAP")>
				if (message.dataType() == 0)
					MapVariables.clientSide.read(message.data(), client.level.registryAccess());
				</#if>
				<#if w.hasVariablesOfScope("GLOBAL_WORLD")>
				if (message.dataType() == 1)
					WorldVariables.clientSide.read(message.data(), client.level.registryAccess());
				</#if>
				<#if w.hasVariablesOfScope("PLAYER_LIFETIME") || w.hasVariablesOfScope("PLAYER_PERSISTENT")>
				if (message.dataType() == 2 && client.player != null) {
					PlayerVariables vars = PLAYER_CACHE.computeIfAbsent(client.player.getUUID(), key -> new PlayerVariables());
					vars.deserializeNBT(client.level.registryAccess(), message.data());
				}
				</#if>
			});
		}
	}
}
<#-- @formatter:on -->
