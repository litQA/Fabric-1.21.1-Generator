# Builds the generator plugin archive through the Gradle project in the plugin workspace.
# Output: <repo>/build/generator-fabric-1.21.1.zip

$ErrorActionPreference = 'Stop'

$pluginRoot = Split-Path -Parent $PSScriptRoot
$repoRoot = Split-Path -Parent $pluginRoot
$output = Join-Path $repoRoot 'build'
$archive = Join-Path $output 'generator-fabric-1.21.1.zip'

New-Item -ItemType Directory -Force -Path $output | Out-Null

$gradle = Join-Path $repoRoot 'caches\gradle-dist\gradle-9.8.0\bin\gradle.bat'
$gradleUserHome = Join-Path $repoRoot 'caches\gradle'
$javaHome = Join-Path $repoRoot 'MCreatorEAP2026344621\jdk'

if (Test-Path $gradle) {
    $env:JAVA_HOME = $javaHome
    $env:GRADLE_USER_HOME = $gradleUserHome
    Push-Location $pluginRoot
    try {
        & $gradle buildPlugin --console=plain --no-daemon --no-watch-fs
        if ($LASTEXITCODE -ne 0) {
            throw "Gradle buildPlugin failed with exit code $LASTEXITCODE"
        }
    } finally {
        Pop-Location
    }
    $built = Join-Path $pluginRoot 'build\dist\generator-fabric-1.21.1.zip'
    if (-not (Test-Path $built)) {
        throw "Gradle did not produce the plugin archive: $built"
    }
    Copy-Item $built $archive -Force
} else {
    Write-Host 'Gradle distribution not found, packaging manually.'
    $staging = Join-Path $output 'plugin-staging'
    if (Test-Path $staging) { Remove-Item $staging -Recurse -Force }
    New-Item -ItemType Directory -Path $staging -Force | Out-Null
    Copy-Item (Join-Path $pluginRoot 'plugin.json') $staging -Force
    Copy-Item (Join-Path $pluginRoot 'LICENSE') $staging -Force
    Copy-Item (Join-Path $pluginRoot 'src\main\resources\fabric-1.21.1') (Join-Path $staging 'fabric-1.21.1') -Recurse -Force
    if (Test-Path $archive) { Remove-Item $archive -Force }
    Compress-Archive -Path (Join-Path $staging '*') -DestinationPath $archive -CompressionLevel Optimal
    Remove-Item $staging -Recurse -Force
}

Write-Host "Plugin archive written to $archive"
