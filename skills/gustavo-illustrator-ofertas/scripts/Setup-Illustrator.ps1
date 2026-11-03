[CmdletBinding()]
param([string]$VersionLabel,[string[]]$ProductRoots=@(),[string]$RepositoryUrl='https://github.com/Guhvlr/chat-gpt-ofertas.git',[string]$RepositoryBranch='main',[string]$SettingsPath,[switch]$StartIfNeeded,[switch]$NonInteractive)
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'Illustrator-Common.ps1')
Assert-IllustratorHost
if (-not $VersionLabel) {
    if ($NonInteractive) { throw 'VersionLabel obrigatorio no modo nao interativo.' }
    Write-Host 'Qual a versao do seu Illustrator? Exemplos: 2024, 2025, 2026 ou 28.1.'
    $detected=@(Get-IllustratorRegistrations | Sort-Object Major)
    if ($detected.Count) { Write-Host ('Versoes registradas: '+(($detected | ForEach-Object {$_.Major}) -join ', ')) }
    $VersionLabel=Read-Host 'Versao'
}
$major=Resolve-IllustratorMajor $VersionLabel
if ($ProductRoots.Count -eq 0 -and -not $NonInteractive) {
    $inputRoots=Read-Host 'Pastas das fotos, separadas por ponto e virgula (pode configurar depois)'
    $ProductRoots=@($inputRoots.Split(';') | ForEach-Object {$_.Trim().Trim('"')} | Where-Object {$_})
}
$roots=@($ProductRoots | ForEach-Object {[IO.Path]::GetFullPath($_)})
foreach ($r in $roots) {if (-not (Test-Path -LiteralPath $r -PathType Container)) {Write-Warning ('Pasta indisponivel neste PC: '+$r)}}
$connectionError=$null; $version=$null; $ready=$false
try {$c=Get-IllustratorConnection -Major $major -StartIfNeeded:$StartIfNeeded; $version=$c.Version; $ready=$true} catch {$connectionError=$_.Exception.Message}
$path=Get-SettingsPath $SettingsPath
New-Item -ItemType Directory -Path (Split-Path -Parent $path) -Force | Out-Null
$settings=[ordered]@{schemaVersion=1;illustratorMajor=$major;versionInput=$VersionLabel;progId=('Illustrator.Application.'+$major);productRoots=$roots;repositoryUrl=$RepositoryUrl;repositoryBranch=$RepositoryBranch;connectionReady=$ready;lastVerifiedVersion=$version;lastCheckUtc=[DateTime]::UtcNow.ToString('o');connectionError=$connectionError}
$settings | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $path -Encoding UTF8
[pscustomobject]@{configured=$true;connectionReady=$ready;version=$version;settingsPath=$path;connectionError=$connectionError} | ConvertTo-Json -Depth 4
