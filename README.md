# Fabric 1.21.1 Generator for MCreator

Generator plugin for MCreator EAP 2026344621 that produces clean Fabric 1.21.1 mods.

| Property | Value |
| --- | --- |
| Generator id | `generator-fabric-1.21.1` |
| Version | `2026.3-1.0.0-beta` |
| Minecraft | 1.21.1 |
| Fabric Loader | 0.20.1 |
| Fabric API | 0.116.17 |
| Java | 21 bytecode, compiled with JDK 25 |
| Author | LitQA |
| License | CC BY-NC 4.0 |

## Repository Layout

The repository keeps the plugin project separated from tooling, caches and test workspaces:

```
plugin/                      MCreator plugin project (this folder)
  plugin.json                MCreator plugin descriptor (plugin id, version, supported MCreator builds)
  fabric-1.21.1/             Generator definition consumed by MCreator
    generator.yaml           Generator configuration, imports and base templates
    common.blocks.yaml       Global templates for the block and item init classes
    common.items.yaml
    templates/               Overridden Fabric templates (blocks, items, tabs, procedures, mod base)
    procedures/              Procedure block templates (entity, world, item, block, state, math, ...)
    utils/                   Shared template functions (mcitems, procedures, triggers)
    workspacebase/           Files copied into every new mod workspace (Gradle, wrapper, run files)
  tools/                     Build and verification helpers
    check-templates.ps1      FreeMarker and YAML validation of the shipped generator
    build-verification.ps1   Compiles the verification workspace against real Fabric dependencies
    build-plugin.ps1         Packages build/generator-fabric-1.21.1.zip
    sandbox/                 Local sandbox workarounds used only for the verification build
  LICENSE, CHANGELOG.md, MIGRATION-REPORT.md, README.md
参考资源/                     Reference generators and the local Gradle distribution
MCreatorEAP2026344621/       MCreator EAP installation (bundled JDK and libraries)
caches/                      All Gradle / Loom / distribution caches, never written to C:
workspace/                   Verification, replay and probe workspaces
用户测试/                     Workspace supplied for the real-device test
build/                       Packaged plugin archives
```

## Development Rules

- All caches are redirected into `caches/`. Gradle always runs with
  `GRADLE_USER_HOME=<repo>/caches/gradle`; the Gradle wrapper distribution points to the local
  `参考资源/gradle-9.8.0-bin.zip` archive.
- Generated code must not contain `net.neoforged`, `@Mod`, `@EventBusSubscriber`, capability or
  `DeferredRegister` constructs.
- Mixins live in the dedicated `net.mcreator.<modid>.mixin` package.
- Development stops after the local compile check of a phase until the real-device test is performed.

## Local Instructions

```powershell
# Parse all shipped templates and load all shipped YAML definitions
pwsh plugin/tools/check-templates.ps1

# Compile the verification workspace against Fabric 1.21.1
pwsh plugin/tools/build-verification.ps1

# Package the plugin into build/generator-fabric-1.21.1.zip
pwsh plugin/tools/build-plugin.ps1
```
