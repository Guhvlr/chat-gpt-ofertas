[CmdletBinding()]
param([ValidateSet('Inspect','Prepare','Checkpoint')][string]$Mode='Inspect',[Parameter(Mandatory=$true)][string]$DocumentName,[string]$OutputPath,[string]$Validity,[string]$SettingsPath,[string]$StatePath)
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'Illustrator-Common.ps1')
Assert-IllustratorHost
if (-not $StatePath) {$StatePath=Join-Path (Split-Path -Parent (Get-SettingsPath $SettingsPath)) 'work-files.json'}
$state=@()
if (Test-Path -LiteralPath $StatePath) {$state=@(Get-Content -LiteralPath $StatePath -Raw -Encoding UTF8 | ConvertFrom-Json)}
$cfg=Read-IllustratorSettings $SettingsPath
$connection=Get-IllustratorConnection -Major $cfg.illustratorMajor
$ai=$connection.Application
$name=ConvertTo-Json -InputObject $DocumentName -Compress
$metaScript='(function(){var d=app.documents.getByName('+$name+'); var p="";try{p=d.fullName.fsName;}catch(e){} return encodeURIComponent(d.name)+"|"+encodeURIComponent(p)+"|"+(d.saved?"1":"0");}());'
$meta=([string]$ai.DoJavaScript($metaScript)).Split('|')
$path=[uri]::UnescapeDataString($meta[1])
if ($path -and -not (Test-Path -LiteralPath $path -PathType Leaf)) {$path=''}
$known=@($state | Where-Object {$path -and $_.workingPath -eq $path})
if ($Mode -eq 'Inspect') {
    [pscustomobject]@{documentName=[uri]::UnescapeDataString($meta[0]);workingPath=$path;needsDestination=($known.Count -eq 0);validity=$(if($known.Count){$known[0].validity}else{$null});saved=($meta[2] -eq '1')} | ConvertTo-Json
    return
}
if ($Mode -eq 'Checkpoint' -and $known.Count -eq 0) {throw 'Primeiro confirme pasta, nome e validade e execute Prepare. Nenhum documento salvo.'}
if ($Mode -eq 'Prepare' -and $known.Count -eq 0 -and (-not $OutputPath -or -not $Validity)) {throw 'Novo arquivo: informe OutputPath e Validity confirmados pelo usuario.'}
if ($known.Count -and $OutputPath -and [IO.Path]::GetFullPath($OutputPath) -ne $path) {throw 'Destino diferente: trate como novo trabalho, sem substituir o registro atual.'}
$destination=$path
if ($Mode -eq 'Prepare' -and $known.Count -eq 0) {
    if (-not [IO.Path]::IsPathRooted($OutputPath) -or [IO.Path]::GetExtension($OutputPath) -ne '.ai') {throw 'Escolha um caminho absoluto terminado em .ai.'}
    $destination=[IO.Path]::GetFullPath($OutputPath)
    if ($destination -ne $path -and (Test-Path -LiteralPath $destination)) {throw 'Destino ja existe. Escolha outro nome ou abra o arquivo existente e confirme seu uso.'}
    if (-not (Test-Path -LiteralPath (Split-Path -Parent $destination) -PathType Container)) {throw 'Pasta de destino inexistente. Crie a pasta confirmada antes de salvar.'}
}
$code='var d=app.documents.getByName('+$name+');d.activate();'
if ($destination -eq $path) {$code+='d.save();'}
else {$quoted=ConvertTo-Json -InputObject $destination -Compress; $code+='var opts=new IllustratorSaveOptions();opts.pdfCompatible=true;d.saveAs(new File('+$quoted+'),opts);'}
$code+='d.saved ? "saved" : "pending";'
$result=[string]$ai.DoJavaScript($code)
if ($result -ne 'saved' -or -not (Test-Path -LiteralPath $destination -PathType Leaf)) {throw 'Illustrator nao confirmou o salvamento. Pare e verifique o documento.'}
$valid=$Validity
if (-not $valid -and $known.Count) {$valid=$known[0].validity}
$records=@($state | Where-Object {$_.workingPath -ne $destination})
$records+= [pscustomobject]@{workingPath=$destination;sourcePath=$(if($known.Count){$known[0].sourcePath}else{$path});validity=$valid;lastSavedUtc=[DateTime]::UtcNow.ToString('o')}
New-Item -ItemType Directory -Path (Split-Path -Parent $StatePath) -Force | Out-Null
$temporary=$StatePath+'.'+[Guid]::NewGuid().ToString('N')+'.tmp'
ConvertTo-Json -InputObject @($records) -Depth 5 | Set-Content -LiteralPath $temporary -Encoding UTF8
if (Test-Path -LiteralPath $StatePath) {[IO.File]::Replace($temporary,$StatePath,$StatePath+'.bak')} else {[IO.File]::Move($temporary,$StatePath)}
[pscustomobject]@{saved=$true;workingPath=$destination;documentName=[IO.Path]::GetFileName($destination);validity=$valid;statePath=$StatePath} | ConvertTo-Json
