[CmdletBinding()]
param([ValidateSet('Status','ListDocuments','Script')][string]$Mode='Status',[string]$SettingsPath,[string]$ScriptPath,[string]$DocumentName,[switch]$StartIfNeeded)
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'Illustrator-Common.ps1')
Assert-IllustratorHost
$cfg=Read-IllustratorSettings $SettingsPath
$connection=Get-IllustratorConnection -Major $cfg.illustratorMajor -StartIfNeeded:$StartIfNeeded
$ai=$connection.Application
if ($Mode -eq 'Status') {
    [pscustomobject]@{connected=$true;version=$connection.Version;documentCount=$ai.Documents.Count} | ConvertTo-Json
} elseif ($Mode -eq 'ListDocuments') {
    $ai.DoJavaScriptFile((Join-Path $PSScriptRoot 'list-documents.jsx'))
} else {
    if (-not $DocumentName) {throw 'Informe o nome exato do documento em DocumentName.'}
    if (-not (Test-Path -LiteralPath $ScriptPath -PathType Leaf) -or [IO.Path]::GetExtension($ScriptPath) -notin @('.jsx','.js')) {throw 'Informe um arquivo JSX/JS existente.'}
    $work=& (Join-Path $PSScriptRoot 'Save-Work.ps1') -Mode Inspect -DocumentName $DocumentName -SettingsPath $SettingsPath | ConvertFrom-Json
    if ($work.needsDestination) {throw 'Confirme destino e validade e execute Save-Work.ps1 -Mode Prepare antes de editar.'}
    $quoted=ConvertTo-Json -InputObject $DocumentName -Compress
    $ai.DoJavaScript('app.documents.getByName('+$quoted+').activate();') | Out-Null
    $ai.DoJavaScriptFile([IO.Path]::GetFullPath($ScriptPath))
    & (Join-Path $PSScriptRoot 'Save-Work.ps1') -Mode Checkpoint -DocumentName $DocumentName -SettingsPath $SettingsPath
}
