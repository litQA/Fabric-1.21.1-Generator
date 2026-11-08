# Parses every shipped template and loads every shipped YAML definition.
# Layout: <repo>/plugin holds the plugin sources, <repo> holds MCreator and the localized caches.

$ErrorActionPreference = 'Stop'

$pluginRoot = Split-Path -Parent $PSScriptRoot
$repoRoot = Split-Path -Parent $pluginRoot

$java = Join-Path $repoRoot 'MCreatorEAP2026344621\jdk\bin\java.exe'
$lib = Join-Path $repoRoot 'MCreatorEAP2026344621\lib'
$generator = Join-Path $pluginRoot 'src\main\resources\fabric-1.21.1'

if (-not (Test-Path $java)) {
    throw "Bundled JDK not found: $java"
}

Write-Host 'Checking FreeMarker templates...'
& $java -cp (Join-Path $lib 'freemarker-2.3.35.jar') (Join-Path $PSScriptRoot 'CheckTemplates.java') $generator
if ($LASTEXITCODE -ne 0) {
    throw 'Template check failed'
}

Write-Host 'Checking YAML definitions...'
& $java -cp (Join-Path $lib 'snakeyaml-engine-3.2.jar') (Join-Path $PSScriptRoot 'ValidateYaml.java') $generator
if ($LASTEXITCODE -ne 0) {
    throw 'YAML check failed'
}


Write-Host 'Checking template include paths...'
$includeErrors = @()
Get-ChildItem (Join-Path $generator 'templates') -Recurse -File -Filter *.ftl | ForEach-Object {
    $relative = $_.FullName.Substring((Join-Path $generator 'templates').Length + 1)
    $depth = ($relative -split '\\').Count - 1
    $bare = Select-String -Path $_.FullName -Pattern '<#include "(mcitems|procedures\.java|triggers\.java|boundingboxes)\.ftl"'
    $parent = Select-String -Path $_.FullName -Pattern '<#include "\.\./(mcitems|procedures\.java|triggers\.java|boundingboxes)\.ftl"'
    if ($depth -ge 1 -and $bare) {
        $includeErrors += "$relative uses bare utility include from a sub directory (use ../)"
    }
    if ($depth -eq 0 -and $parent) {
        $includeErrors += "$relative uses ../ utility include from the template root (use the bare name)"
    }
}
if ($includeErrors.Count -ne 0) {
    $includeErrors | ForEach-Object { Write-Host "  FAIL $_" }
    throw 'Template include path check failed'
}


Write-Host 'Checking template includes resolve inside the generator...'
$includeFiles = Get-ChildItem (Join-Path $generator 'templates') -Recurse -File -Filter *.ftl
$known = @{}
Get-ChildItem (Join-Path $generator 'utils') -Recurse -File | ForEach-Object { $known[$_.Name] = $true }
Get-ChildItem (Join-Path $generator 'templates') -Recurse -File | ForEach-Object { $known[$_.Name] = $true }
$errors = @()
foreach ($file in $includeFiles) {
    $content = [System.IO.File]::ReadAllText($file.FullName)
    foreach ($match in [regex]::Matches($content, '<#include "([^"]+)"')) {
        $include = $match.Groups[1].Value
        $base = Split-Path $include -Leaf
        if (-not $known.ContainsKey($base)) {
            $errors += "$($file.FullName.Substring((Join-Path $generator 'templates').Length + 1)) includes missing template $include"
        }
    }
}
if ($errors.Count -ne 0) {
    $errors | Sort-Object -Unique | ForEach-Object { Write-Host "  FAIL $_" }
    throw 'Template include resolution check failed'
}


Write-Host 'Checking loader specific APIs are not used...'
# Loader specific APIs of the NeoForge generator. None of these may survive in the Fabric generator.
$forbidden = @(
    'net.neoforged', '@EventBusSubscriber', '@SubscribeEvent', '@Mod(',
    'DeferredRegister', 'DeferredHolder', 'DeferredItem', 'DeferredBlock',
    'ILevelExtension', 'IItemHandler', 'IFluidHandler', 'IEnergyStorage', 'Capability',
    'getUnsidedLevel', 'FakePlayerFactory', 'getBuildContext', 'getCommandSelection',
    'BlockTags.create(', 'ItemTags.create(',
    'shouldTriggerClientSideContainerClosingOnOpen',
    'FMLCommonSetupEvent', 'FMLClientSetupEvent', 'FMLDedicatedServerSetupEvent',
    'RegisterCommandsEvent', 'RegisterClientCommandsEvent',
    'PlayerInteractEvent', 'LivingIncomingDamageEvent', 'LivingDeathEvent',
    'LivingDamageEvent', 'LivingHealEvent', 'LivingFallEvent', 'LivingJumpEvent',
    'LivingEquipmentChangeEvent', 'LivingSwapItemsEvent', 'LivingChangeTargetEvent',
    'LivingUseTotemEvent', 'LivingShieldBlockEvent', 'EntityJoinLevelEvent',
    'EntityTickEvent', 'LevelTickEvent', 'PlayerTickEvent', 'PlayerEvent.',
    'ServerChatEvent', 'CommandEvent', 'CropGrowEvent', 'BonemealEvent',
    'BlockEvent.', 'ExplosionEvent', 'ItemTossEvent', 'ItemExpireEvent',
    'ItemEntityPickupEvent', 'PlayerXpEvent', 'AdvancementEvent',
    'AnimalTameEvent', 'PlayerDestroyItemEvent', 'CriticalHitEvent',
    'EntityTravelToDimensionEvent', 'BlockGrowFeatureEvent', 'VillageSiegeEvent',
    'EntityStruckByLightningEvent', 'ItemFishedEvent', 'CanPlayerSleepEvent',
    'PlayerWakeUpEvent', 'EntityMobGriefingEvent', 'LivingExperienceDropEvent',
    'PacketDistributor', 'CustomPacketPayload.Type<>()', 'IPayloadContext'
)
$apiErrors = @()
Get-ChildItem $generator -Recurse -File | Where-Object { $_.Extension -in '.ftl', '.yaml' } | ForEach-Object {
    $text = [System.IO.File]::ReadAllText($_.FullName)
    foreach ($pattern in $forbidden) {
        if ($text.Contains($pattern)) {
            $apiErrors += "$($_.FullName.Substring($generator.Length + 1)) contains $pattern"
        }
    }
}
if ($apiErrors.Count -ne 0) {
    $apiErrors | Sort-Object -Unique | ForEach-Object { Write-Host "  FAIL $_" }
    throw 'Loader API check failed'
}


Write-Host 'Checking templates for stray characters...'
$stray = @()
Get-ChildItem $generator -Recurse -File -Filter *.ftl | ForEach-Object {
    if ([System.IO.File]::ReadAllText($_.FullName).Contains('`')) {
        $stray += $_.FullName.Substring($generator.Length + 1)
    }
}
if ($stray.Count -ne 0) {
    $stray | ForEach-Object { Write-Host "  FAIL stray backtick in $_" }
    throw 'Template character check failed'
}


Write-Host 'Checking menu opening calls...'
$menuErrors = @()
Get-ChildItem $generator -Recurse -File -Filter *.ftl | ForEach-Object {
    $text = [System.IO.File]::ReadAllText($_.FullName)
    if ($text -match 'openMenu\([^)]*,[^)]*\)') {
        $menuErrors += "$($_.FullName.Substring($generator.Length + 1)) passes extra arguments to openMenu"
    }
}
if ($menuErrors.Count -ne 0) {
    $menuErrors | ForEach-Object { Write-Host "  FAIL $_" }
    throw 'Menu opening check failed'
}


Write-Host 'Checking particle type accessors...'
$particleErrors = @()
Get-ChildItem $generator -Recurse -File | Where-Object { $_.Extension -in '.ftl', '.yaml' } | ForEach-Object {
    $lines = [System.IO.File]::ReadAllLines($_.FullName)
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match 'ParticleTypes\.\w+\.get\(') {
            $particleErrors += "$($_.FullName.Substring($generator.Length + 1)):$($i + 1) appends a loader accessor to a particle type"
        }
    }
}
if ($particleErrors.Count -ne 0) {
    $particleErrors | ForEach-Object { Write-Host "  FAIL $_" }
    throw 'Particle accessor check failed'
}

Write-Host 'Template and definition checks passed.'

