[CmdletBinding()]
param([int]$Port=0,[string]$SessionPath,[string]$SettingsPath,[string]$SkillsDirectory,[int]$IdleMinutes=120)
$ErrorActionPreference='Stop'
$PackageRoot=Split-Path -Parent $PSScriptRoot
$BundledSkill=Join-Path $PackageRoot 'skills/gustavo-illustrator-ofertas'
. (Join-Path $BundledSkill 'scripts/Illustrator-Common.ps1')
Assert-IllustratorHost
if (-not $SessionPath) {$SessionPath=Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'GustavoIllustrator/central-session.json'}
function Find-InstalledSkill {
    $candidates=@()
    if ($SkillsDirectory) {$candidates+=Join-Path $SkillsDirectory 'gustavo-illustrator-ofertas'}
    else {$candidates+=Join-Path $env:USERPROFILE '.agents/skills/gustavo-illustrator-ofertas'; $candidates+=Join-Path $env:USERPROFILE '.codex/skills/gustavo-illustrator-ofertas'}
    foreach ($candidate in $candidates) {if (Test-Path -LiteralPath (Join-Path $candidate 'SKILL.md') -PathType Leaf) {return $candidate}}
    return ''
}
function Get-CentralStatus {
    $versions=@(Get-IllustratorRegistrations | Sort-Object Major -Descending | ForEach-Object {
        $label='Illustrator '+$_.Major
        if ($_.Major -ge 24 -and $_.Major -le 30) {$label='Illustrator '+($_.Major+1996)+' - versao '+$_.Major}
        [pscustomobject]@{major=$_.Major;label=$label}
    })
    $installed=Find-InstalledSkill
    $cfg=$null; $connected=$false; $activeVersion=$null
    if (Test-Path -LiteralPath (Get-SettingsPath $SettingsPath)) {
        $cfg=Read-IllustratorSettings $SettingsPath
        try {$c=Get-IllustratorConnection -Major $cfg.illustratorMajor; $connected=$true; $activeVersion=$c.Version} catch {}
    }
    $prompt='Use $gustavo-illustrator-ofertas. Busque as orientacoes e referencias aprovadas mais recentes da equipe e aguarde minha tarefa para o Illustrator. Nao altere nenhuma oferta ainda.'
    $chatUrl='codex://new?path='+[uri]::EscapeDataString($PackageRoot)+'&prompt='+[uri]::EscapeDataString($prompt)
    [pscustomobject]@{versions=@($versions);installed=[bool]$installed;configured=[bool]$cfg;configuredVersion=$(if($cfg){[string]$cfg.illustratorMajor}else{''});connected=$connected;activeVersion=$activeVersion;gitAvailable=[bool](Get-Command git.exe -ErrorAction SilentlyContinue);chatUrl=$chatUrl}
}
function Respond([IO.Stream]$Stream,[int]$Status,[string]$Type,[byte[]]$Body) {
    $reasons=@{200='OK';400='Bad Request';403='Forbidden';404='Not Found';405='Method Not Allowed';500='Internal Server Error'}
    $header="HTTP/1.1 $Status $($reasons[$Status])`r`nContent-Type: $Type`r`nContent-Length: $($Body.Length)`r`nConnection: close`r`nCache-Control: no-store`r`nX-Content-Type-Options: nosniff`r`nReferrer-Policy: no-referrer`r`nContent-Security-Policy: default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self' blob:; connect-src 'self'; frame-ancestors 'none'; base-uri 'none'; form-action 'none'`r`n`r`n"
    $bytes=[Text.Encoding]::ASCII.GetBytes($header)
    $Stream.Write($bytes,0,$bytes.Length); $Stream.Write($Body,0,$Body.Length); $Stream.Flush()
}
function Json-Response([IO.Stream]$Stream,[int]$Status,$Value) {
    $json=ConvertTo-Json -InputObject $Value -Depth 8 -Compress
    Respond $Stream $Status 'application/json; charset=utf-8' ([Text.Encoding]::UTF8.GetBytes($json))
}
$rng=[Security.Cryptography.RandomNumberGenerator]::Create(); $secretBytes=New-Object byte[] 32; $rng.GetBytes($secretBytes); $rng.Dispose()
$secret=([BitConverter]::ToString($secretBytes)).Replace('-','').ToLowerInvariant()
$listener=[Net.Sockets.TcpListener]::new([Net.IPAddress]::Loopback,$Port)
$listener.Start()
$actualPort=$listener.LocalEndpoint.Port
$origin='http://127.0.0.1:'+$actualPort
$session=[ordered]@{pid=$PID;url=($origin+'/#session='+$secret);origin=$origin;token=$secret;packageRoot=$PackageRoot;startedUtc=[DateTime]::UtcNow.ToString('o')}
New-Item -ItemType Directory -Path (Split-Path -Parent $SessionPath) -Force | Out-Null
$session | ConvertTo-Json | Set-Content -LiteralPath $SessionPath -Encoding UTF8
$running=$true; $lastActivity=[DateTime]::UtcNow
Write-Output ('Central local iniciada na porta '+$actualPort+'.')
try {
    while ($running -and ([DateTime]::UtcNow-$lastActivity).TotalMinutes -lt $IdleMinutes) {
        if (-not $listener.Pending()) {Start-Sleep -Milliseconds 100; continue}
        $client=$listener.AcceptTcpClient(); $client.ReceiveTimeout=8000; $client.SendTimeout=8000; $stream=$client.GetStream()
        try {
            $headerBuffer=New-Object 'System.Collections.Generic.List[byte]'
            while ($true) {
                $b=$stream.ReadByte(); if ($b -lt 0) {throw 'Requisicao incompleta.'}; $headerBuffer.Add([byte]$b)
                $n=$headerBuffer.Count
                if ($n -gt 16384) {throw 'Cabecalho muito grande.'}
                if ($n -ge 4 -and $headerBuffer[$n-4] -eq 13 -and $headerBuffer[$n-3] -eq 10 -and $headerBuffer[$n-2] -eq 13 -and $headerBuffer[$n-1] -eq 10) {break}
            }
            $lines=[Text.Encoding]::ASCII.GetString($headerBuffer.ToArray()).Split(@("`r`n"),[StringSplitOptions]::None)
            $parts=$lines[0].Split(' '); if ($parts.Count -ne 3) {throw 'Requisicao invalida.'}
            $method=$parts[0]; $path=$parts[1]; $headers=@{}
            foreach ($line in $lines[1..($lines.Length-1)]) {if ($line) {$colon=$line.IndexOf(':'); if ($colon -le 0) {throw 'Cabecalho invalido.'}; $key=$line.Substring(0,$colon).Trim().ToLowerInvariant(); if ($headers.ContainsKey($key)) {throw 'Cabecalho duplicado.'}; $headers[$key]=$line.Substring($colon+1).Trim()}}
            if (-not $headers.ContainsKey('host') -or $headers['host'] -ne ('127.0.0.1:'+$actualPort)) {Json-Response $stream 403 @{error='Origem local invalida.'}; continue}
            if ($headers.ContainsKey('origin') -and $headers['origin'] -ne $origin) {Json-Response $stream 403 @{error='Origem nao autorizada.'}; continue}
            if ($method -notin @('GET','POST')) {Json-Response $stream 405 @{error='Metodo nao permitido.'}; continue}
            $public=@{'/'=@('index.html','text/html; charset=utf-8');'/app.js'=@('app.js','text/javascript; charset=utf-8');'/style.css'=@('style.css','text/css; charset=utf-8');'/favicon.svg'=@('favicon.svg','image/svg+xml')}
            if ($method -eq 'GET' -and $public.ContainsKey($path)) {$asset=$public[$path]; Respond $stream 200 $asset[1] ([IO.File]::ReadAllBytes((Join-Path $PSScriptRoot $asset[0]))); continue}
            if (-not $path.StartsWith('/api/')) {Json-Response $stream 404 @{error='Pagina nao encontrada.'}; continue}
            if (-not $headers.ContainsKey('authorization') -or $headers['authorization'] -cne ('Bearer '+$secret)) {Json-Response $stream 403 @{error='Sessao local ausente ou expirada. Abra Central.cmd novamente.'}; continue}
            $lastActivity=[DateTime]::UtcNow
            if ($method -eq 'GET') {
                switch ($path) {
                    '/api/status' {Json-Response $stream 200 (Get-CentralStatus)}
                    '/api/reference' {
                        $installed=Find-InstalledSkill; $refRoot=$BundledSkill; if ($installed) {$refRoot=$installed}
                        $image=Join-Path $refRoot 'references/layout-referencia-usuario/visao-geral.jpg'
                        Respond $stream 200 'image/jpeg' ([IO.File]::ReadAllBytes($image))
                    }
                    default {Json-Response $stream 404 @{error='Operacao nao encontrada.'}}
                }
                continue
            }
            if (-not $headers.ContainsKey('content-type') -or $headers['content-type'] -notmatch '^application/json(?:;|$)') {Json-Response $stream 400 @{error='Envie dados JSON.'}; continue}
            $length=0
            if (-not $headers.ContainsKey('content-length') -or -not [int]::TryParse($headers['content-length'],[ref]$length) -or $length -lt 0 -or $length -gt 4096 -or $headers.ContainsKey('transfer-encoding')) {Json-Response $stream 400 @{error='Tamanho de requisicao invalido.'}; continue}
            $bodyBytes=New-Object byte[] $length; $read=0
            while ($read -lt $length) {$count=$stream.Read($bodyBytes,$read,$length-$read); if ($count -eq 0) {throw 'Corpo incompleto.'}; $read+=$count}
            $body=[Text.Encoding]::UTF8.GetString($bodyBytes) | ConvertFrom-Json
            switch ($path) {
                '/api/install' {
                    if (-not $body -or $body.PSObject.Properties.Name -notcontains 'version' -or [string]$body.version -notmatch '^(?:20(?:20|21|22|23|24|25|26)|[2-9][0-9](?:\.[0-9]+){0,2})$') {Json-Response $stream 400 @{error='Escolha uma versao valida do Illustrator.'}; break}
                    $installParams=@{VersionLabel=[string]$body.version;NonInteractive=$true}
                    if ($SettingsPath) {$installParams.SettingsPath=$SettingsPath}; if ($SkillsDirectory) {$installParams.SkillsDirectory=$SkillsDirectory}
                    $result=(& (Join-Path $PackageRoot 'Instalar.ps1') @installParams | Out-String) | ConvertFrom-Json
                    $message='Skill instalada. A conexao ainda precisa de atencao: '+$result.connectionError
                    if ($result.connectionReady) {$message='Tudo pronto! Skill instalada e Illustrator conectado. Clique em Iniciar conversa para continuar no Codex.'}
                    Json-Response $stream 200 @{message=$message;warning=(-not $result.connectionReady);status=(Get-CentralStatus)}
                }
                '/api/test' {
                    $cfg=Read-IllustratorSettings $SettingsPath
                    $c=Get-IllustratorConnection -Major $cfg.illustratorMajor
                    Json-Response $stream 200 @{message=('Conexao confirmada com o Illustrator '+$c.Version+'. Nenhuma arte foi alterada.');status=(Get-CentralStatus)}
                }
                '/api/update' {
                    $installed=Find-InstalledSkill; if (-not $installed) {throw 'Instale a skill antes de atualizar.'}
                    $updater=Join-Path $installed 'scripts/Update-Skill.ps1'; if (-not (Test-Path -LiteralPath $updater)) {$updater=Join-Path $BundledSkill 'scripts/Update-Skill.ps1'}
                    $updated=& $updater -SettingsPath $SettingsPath -InstalledSkillPath $installed | ConvertFrom-Json
                    Json-Response $stream 200 @{message=('Skill e referencias atualizadas. '+$updated.changedFiles+' arquivos alterados; configuracoes locais preservadas.');status=(Get-CentralStatus)}
                }
                '/api/stop' {$running=$false; Json-Response $stream 200 @{stopped=$true}}
                default {Json-Response $stream 404 @{error='Operacao nao encontrada.'}}
            }
        } catch {
            try {Json-Response $stream 500 @{error=$_.Exception.Message}} catch {}
        } finally {$stream.Dispose(); $client.Close()}
    }
} finally {
    $listener.Stop()
    if (Test-Path -LiteralPath $SessionPath) {
        try {$record=Get-Content -LiteralPath $SessionPath -Raw -Encoding UTF8 | ConvertFrom-Json; if ($record.pid -eq $PID) {Remove-Item -LiteralPath $SessionPath}} catch {}
    }
}
