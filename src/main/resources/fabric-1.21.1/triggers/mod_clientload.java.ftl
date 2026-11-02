public class ${name}Procedure {

	static {
		if (net.fabricmc.loader.api.FabricLoader.getInstance().getEnvironmentType() == net.fabricmc.api.EnvType.CLIENT)
			execute();
	}

	public ${name}Procedure() {
	}
