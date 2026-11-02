# Packages the generator plugin into <repo>/build/generator-fabric-1.21.1.zip in the layout MCreator
# expects: plugin.json and LICENSE at the archive root, the generator definition in fabric-1.21.1.

$ErrorActionPreference = 'Stop'

$pluginRoot = Split-Path -Parent $PSScriptRoot
$repoRoot = Split-Path -Parent $pluginRoot

$output = Join-Path $repoRoot 'build'
$staging = Join-Path $output 'plugin-staging'
$archive = Join-Path $output 'generator-fabric-1.21.1.zip'

if (Test-Path $staging) {
    Remove-Item $staging -Recurse -Force
}
New-Item -ItemType Directory -Path $staging -Force | Out-Null

Copy-Item (Join-Path $pluginRoot 'plugin.json') $staging -Force
Copy-Item (Join-Path $pluginRoot 'LICENSE') $staging -Force
Copy-Item (Join-Path $pluginRoot 'fabric-1.21.1') (Join-Path $staging 'fabric-1.21.1') -Recurse -Force

if (Test-Path $archive) {
    Remove-Item $archive -Force
}
Compress-Archive -Path (Join-Path $staging '*') -DestinationPath $archive -CompressionLevel Optimal

Remove-Item $staging -Recurse -Force

Write-Host "Plugin archive written to $archive"
