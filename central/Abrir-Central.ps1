[CmdletBinding()]
param([switch]$NoBrowser)
$ErrorActionPreference='Stop'
$localRoot=Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'GustavoIllustrator'
New-Item -ItemType Directory -Path $localRoot -Force | Out-Null
$sessionPath=Join-Path $localRoot 'central-session.json'
function Get-LiveSession {
    if (-not (Test-Path -LiteralPath $sessionPath)) {return $null}
    try {
        $session=Get-Content -LiteralPath $sessionPath -Raw -Encoding UTF8 | ConvertFrom-Json
        if ($session.origin -notmatch '^http://127\.0\.0\.1:\d+$' -or $session.token -notmatch '^[a-f0-9]{64}$') {return $null}
        $status=Invoke-RestMethod -Uri ($session.origin+'/api/status') -Headers @{Authorization=('Bearer '+$session.token)} -TimeoutSec 5
        return $session
    } catch {return $null}
}
$live=Get-LiveSession
if (-not $live) {
    $server=Join-Path $PSScriptRoot 'Servidor.ps1'
    $arguments='-NoProfile -ExecutionPolicy Bypass -File "'+$server+'"'
    $process=Start-Process -FilePath 'powershell.exe' -ArgumentList $arguments -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $localRoot 'central.log') -RedirectStandardError (Join-Path $localRoot 'central-error.log')
    $deadline=[DateTime]::UtcNow.AddSeconds(15)
    do {
        Start-Sleep -Milliseconds 300
        if ($process.HasExited) {throw ('A Central nao iniciou. Consulte '+(Join-Path $localRoot 'central-error.log'))}
        if (Test-Path -LiteralPath $sessionPath) {
            $candidate=Get-Content -LiteralPath $sessionPath -Raw -Encoding UTF8 | ConvertFrom-Json
            if ($candidate.pid -eq $process.Id) {$live=Get-LiveSession}
        }
    } while (-not $live -and [DateTime]::UtcNow -lt $deadline)
    if (-not $live) {throw 'A Central nao respondeu. Verifique o log local e tente novamente.'}
}
if (-not $NoBrowser) {Start-Process -FilePath $live.url}
Write-Host 'Central Mac Digital pronta. Illustrator disponivel; demais aplicativos em breve.'
