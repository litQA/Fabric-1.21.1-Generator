<img width="1000" alt="fabric generator banner 1 21 1" src="https://github.com/user-attachments/assets/9e82a98d-1d8a-4565-8678-bee1d2e14ff2" />

# Fabric 1.21.1 Generator for MCreator

Generator plugin for MCreator EAP 2026344621 that produces clean Fabric 1.21.1 mods.

| Property | Value |
| --- | --- |
| Generator id | `generator-fabric-1.21.1` |
| Minecraft | 1.21.1 |
| Fabric Loader | 0.20.1 |
| Fabric API | 0.116.17 |
| Java | 21 bytecode, compiled with JDK 25 |
| Author | LitQA |
| License | CC BY-NC 4.0 |


## Local Instructions

```powershell
# Parse all shipped templates and load all shipped YAML definitions
pwsh plugin/tools/check-templates.ps1

# Compile the verification workspace against Fabric 1.21.1
pwsh plugin/tools/build-verification.ps1

# Package the plugin into build/generator-fabric-1.21.1.zip
pwsh plugin/tools/build-plugin.ps1
```
## DSH Empowers Accelerated Plugin Development

<img width="1000" alt="dsh" src="https://github.com/user-attachments/assets/1b0b22c9-5213-48eb-9e51-6de70e852dec" />

This project includes code generated with **DSH (AI)** assistance.

# MCreator - Minecraft Mod Maker

[![MCreator](https://mcreator.net/image/brand/mcreator300s.png)](https://mcreator.net/)

MCreator is an open-source software used to make Minecraft Java Edition mods, Minecraft Bedrock Edition Add-Ons, resource packs, and data packs using an intuitive easy-to-learn interface or with an integrated code editor. It is used worldwide by Minecraft players, aspiring mod developers, for education, online classes, and STEM workshops. 

NOT AN OFFICIAL MINECRAFT PRODUCT. NOT APPROVED BY OR ASSOCIATED WITH MOJANG OR MICROSOFT.
