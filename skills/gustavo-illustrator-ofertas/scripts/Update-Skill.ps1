[CmdletBinding()]
param([string]$SettingsPath,[string]$CachePath,[string]$InstalledSkillPath)
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'Illustrator-Common.ps1')
if (-not $InstalledSkillPath) {$InstalledSkillPath=Split-Path -Parent $PSScriptRoot}
$target=[IO.Path]::GetFullPath($InstalledSkillPath)
$sync=& (Join-Path $PSScriptRoot 'Sync-References.ps1') -SettingsPath $SettingsPath -CachePath $CachePath | ConvertFrom-Json
$source=[IO.Path]::GetFullPath($sync.skillPath)
if ($source -eq $target) {throw 'Execute a atualizacao pela skill instalada, fora do cache.'}
foreach ($dir in @($source,$target)) {
    $entry=Join-Path $dir 'SKILL.md'
    if (-not (Test-Path -LiteralPath $entry) -or (Get-Content -LiteralPath $entry -Raw -Encoding UTF8) -notmatch '(?m)^name: gustavo-illustrator-ofertas\s*$') {throw 'Skill nao reconhecida. Nao sobrescrita.'}
}
$files=@(Get-ChildItem -LiteralPath $source -Recurse -File)
if (@(Get-ChildItem -LiteralPath $source -Recurse -Force | Where-Object {$_.Attributes -band [IO.FileAttributes]::ReparsePoint}).Count) {throw 'Pacote contem link de sistema; atualizacao interrompida.'}
$changed=@($files | Where-Object {
    $relative=$_.FullName.Substring($source.TrimEnd('\').Length).TrimStart('\')
    $dest=Join-Path $target $relative
    -not (Test-Path -LiteralPath $dest) -or (Get-FileHash -LiteralPath $_.FullName).Hash -ne (Get-FileHash -LiteralPath $dest).Hash
})
if ($changed.Count) {
    $backupRoot=Join-Path (Split-Path -Parent (Get-SettingsPath $SettingsPath)) 'backups'
    New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
    Copy-Item -LiteralPath $target -Destination (Join-Path $backupRoot ('skill-'+[DateTime]::Now.ToString('yyyyMMdd-HHmmss-fff'))) -Recurse
    foreach ($file in $changed) {
        $relative=$file.FullName.Substring($source.TrimEnd('\').Length).TrimStart('\')
        $dest=Join-Path $target $relative
        New-Item -ItemType Directory -Path (Split-Path -Parent $dest) -Force | Out-Null
        Copy-Item -LiteralPath $file.FullName -Destination $dest -Force
    }
}
[pscustomobject]@{updated=$true;changedFiles=$changed.Count;commit=$sync.commit;instructionsPath=(Join-Path $target 'SKILL.md');referencesPath=(Join-Path $target 'references')} | ConvertTo-Json
