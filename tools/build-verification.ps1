# Compiles a generated verification workspace against Minecraft 1.21.1, Fabric Loader 0.20.1 and
# Fabric API 0.116.17. All Gradle state stays inside the repository caches folder.

$ErrorActionPreference = 'Stop'

$pluginRoot = Split-Path -Parent $PSScriptRoot
$repoRoot = Split-Path -Parent $pluginRoot

$workspace = Join-Path $repoRoot 'workspace\test-1.21.1'
$gradle = Join-Path $repoRoot 'caches\gradle-dist\gradle-9.8.0\bin\gradle.bat'
$agent = Join-Path $pluginRoot 'tools\sandbox\zip-writable-agent.jar'

if (-not (Test-Path $gradle)) {
    throw "Local Gradle distribution is not extracted: $gradle"
}
if (-not (Test-Path $agent)) {
    throw "Zip writable agent is missing: $agent"
}

$env:JAVA_HOME = Join-Path $repoRoot 'MCreatorEAP2026344621\jdk'
$env:GRADLE_USER_HOME = Join-Path $repoRoot 'caches\gradle'

# The DSH Windows sandbox runs processes at low integrity, where Files.isWritable() reports false for
# writable paths. The agent keeps the JDK zip file system writable so that Loom can write its caches.
# The Gradle distribution also needs the DefaultSettingsPreparer writability check patched, see
# tools/sandbox/PatchGradle.java.

Push-Location $workspace
try {
    & $gradle build --console=plain --no-daemon --no-watch-fs
    if ($LASTEXITCODE -ne 0) {
        throw 'Gradle build failed'
    }
} finally {
    Pop-Location
}

Write-Host 'Verification workspace compiled successfully.'
