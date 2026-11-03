[CmdletBinding()]
param([string]$VersionLabel,[string[]]$ProductRoots=@(),[string]$SkillsDirectory,[string]$SettingsPath,[switch]$NonInteractive,[switch]$DoNotLaunch)
$ErrorActionPreference='Stop'
if ($PSVersionTable.PSVersion.Major -ne 5) {throw 'Execute com powershell.exe (Windows PowerShell 5.1).'}
if (-not $VersionLabel) {
    if ($NonInteractive) {throw 'Informe VersionLabel.'}
    $VersionLabel=Read-Host 'Qual a versao do Illustrator? Ex.: 2024, 2025, 2026 ou 28.1'
}
if (-not $SkillsDirectory) {$SkillsDirectory=Join-Path $env:USERPROFILE '.agents/skills'}
$base=[IO.Path]::GetFullPath($SkillsDirectory).TrimEnd('\','/')
$target=[IO.Path]::GetFullPath((Join-Path $base 'gustavo-illustrator-ofertas'))
if (-not $target.StartsWith($base+[IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase)) {throw 'Destino fora da pasta de skills.'}
$source=Join-Path $PSScriptRoot 'skills/gustavo-illustrator-ofertas'
if (-not (Test-Path -LiteralPath (Join-Path $source 'SKILL.md'))) {throw 'Pacote incompleto.'}
if (Test-Path -LiteralPath $target) {
    $existing=Join-Path $target 'SKILL.md'
    if (-not (Test-Path -LiteralPath $existing) -or (Get-Content -LiteralPath $existing -Raw) -notmatch '(?m)^name: gustavo-illustrator-ofertas\s*$') {throw 'Destino existente nao reconhecido. Nenhum arquivo sobrescrito.'}
    $backupRoot=Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'GustavoIllustrator/backups'
    New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
    Copy-Item -LiteralPath $target -Destination (Join-Path $backupRoot ([DateTime]::Now.ToString('yyyyMMdd-HHmmss-fff'))) -Recurse
}
New-Item -ItemType Directory -Path $target -Force | Out-Null
Get-ChildItem -LiteralPath $source -Force | ForEach-Object {Copy-Item -LiteralPath $_.FullName -Destination $target -Recurse -Force}
Write-Host ('Skill instalada em '+$target)
& (Join-Path $target 'scripts/Setup-Illustrator.ps1') -VersionLabel $VersionLabel -ProductRoots $ProductRoots -SettingsPath $SettingsPath -NonInteractive:$NonInteractive -StartIfNeeded:(-not $DoNotLaunch)
