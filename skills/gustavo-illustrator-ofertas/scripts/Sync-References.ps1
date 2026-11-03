[CmdletBinding()]
param([string]$SettingsPath,[string]$RepositoryUrl,[string]$Branch,[string]$CachePath)
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'Illustrator-Common.ps1')
$cfg=Read-IllustratorSettings $SettingsPath
if (-not $RepositoryUrl) {$RepositoryUrl=$cfg.repositoryUrl}
if (-not $Branch) {$Branch=$cfg.repositoryBranch}
$uri=[uri]$RepositoryUrl
if ($uri.Scheme -ne 'https' -or $uri.Host -ne 'github.com' -or $uri.UserInfo -or $uri.Query -or $uri.Fragment -or $uri.AbsolutePath -notmatch '^/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+/?$') {throw 'Use URL HTTPS de repositorio GitHub, sem credenciais.'}
if ($Branch -notmatch '^[A-Za-z0-9][A-Za-z0-9_./-]*$' -or $Branch.Contains('..')) {throw 'Branch invalida.'}
$git=(Get-Command git.exe -ErrorAction Stop).Source
function Run-Git([string[]]$Arguments) {
    $previous=$ErrorActionPreference
    try {$ErrorActionPreference='Continue'; $result=@(& $git @Arguments 2>&1); $code=$LASTEXITCODE} finally {$ErrorActionPreference=$previous}
    if ($code -ne 0) {throw ('Git falhou: '+($result -join "`n"))}
    return $result
}
if (-not $CachePath) {$CachePath=Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) ('GustavoIllustrator/repos/'+($uri.AbsolutePath.Trim('/') -replace '\.git$','' -replace '/','-'))}
$CachePath=[IO.Path]::GetFullPath($CachePath)
$oldPrompt=$env:GIT_TERMINAL_PROMPT; $oldInteractive=$env:GCM_INTERACTIVE
try {
    $env:GIT_TERMINAL_PROMPT='0'; $env:GCM_INTERACTIVE='Never'
    if (Test-Path -LiteralPath $CachePath) {
        if (-not (Test-Path -LiteralPath (Join-Path $CachePath '.git'))) {throw 'Cache existente nao e repositorio. Escolha outro CachePath.'}
        if ((Run-Git @('-C',$CachePath,'config','--get','remote.origin.url') | Out-String).Trim() -ne $RepositoryUrl) {throw 'Origem do cache diferente da configurada.'}
        if ((Run-Git @('-C',$CachePath,'status','--porcelain') | Out-String).Trim()) {throw 'Cache com alteracoes locais. Preserve e revise antes de sincronizar.'}
        if ((Run-Git @('-C',$CachePath,'branch','--show-current') | Out-String).Trim() -ne $Branch) {throw 'Cache esta em outra branch.'}
        Run-Git @('-C',$CachePath,'fetch','origin',$Branch) | Out-Null
        Run-Git @('-C',$CachePath,'merge','--ff-only',('origin/'+$Branch)) | Out-Null
    } else {
        New-Item -ItemType Directory -Path (Split-Path -Parent $CachePath) -Force | Out-Null
        Run-Git @('clone','--depth','1','--branch',$Branch,'--',$RepositoryUrl,$CachePath) | Out-Null
    }
    $skill=Join-Path $CachePath 'skills/gustavo-illustrator-ofertas'
    if (-not (Test-Path -LiteralPath (Join-Path $skill 'SKILL.md'))) {throw 'Repositorio acessivel, mas pacote da skill ainda nao publicado.'}
    $head=(Run-Git @('-C',$CachePath,'rev-parse','HEAD') | Out-String).Trim()
    $remote=(Run-Git @('-C',$CachePath,'rev-parse',('origin/'+$Branch)) | Out-String).Trim()
    if ($head -ne $remote) {throw 'Cache tem commits locais ainda nao aprovados na origem.'}
    [pscustomobject]@{synced=$true;commit=$head;referencesPath=(Join-Path $skill 'references');repositoryPath=$CachePath} | ConvertTo-Json
} finally {$env:GIT_TERMINAL_PROMPT=$oldPrompt; $env:GCM_INTERACTIVE=$oldInteractive}
