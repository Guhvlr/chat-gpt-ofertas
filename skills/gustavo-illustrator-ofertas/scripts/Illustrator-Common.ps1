Set-StrictMode -Version 2.0
function Assert-IllustratorHost {
    if ($env:OS -ne 'Windows_NT' -or $PSVersionTable.PSVersion.Major -ne 5) { throw 'Execute com Windows PowerShell 5.1 (powershell.exe). Este conector nao suporta macOS ou PowerShell 7.' }
}
function Get-SettingsPath([string]$Override) {
    if ($Override) { return [IO.Path]::GetFullPath($Override) }
    return Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'GustavoIllustrator\settings.json'
}
function Get-IllustratorRegistrations {
    $seen = @{}
    foreach ($view in @([Microsoft.Win32.RegistryView]::Registry64,[Microsoft.Win32.RegistryView]::Registry32)) {
        $root = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::ClassesRoot,$view)
        try { foreach ($key in $root.GetSubKeyNames()) {
            if ($key -match '^Illustrator\.Application\.(\d+)$' -and -not $seen.ContainsKey($key)) {
                $seen[$key]=$true; [pscustomobject]@{ProgId=$key; Major=[int]$Matches[1]}
            }
        }} finally { $root.Close() }
    }
}
function Resolve-IllustratorMajor([string]$Label) {
    $value=$Label.Trim()
    if ($value -match '^(2020|2021|2022|2023|2024|2025|2026)$') { return ([int]$value-1996) }
    if ($value -match '^(?:v)?(\d{2})(?:\.\d+){0,2}$') { return [int]$Matches[1] }
    throw 'Informe o ano (2020 a 2026) ou numero interno, por exemplo 28.1 ou 30. Para outros anos, veja o numero em Ajuda > Sobre o Illustrator.'
}
function Read-IllustratorSettings([string]$SettingsPath) {
    $path=Get-SettingsPath $SettingsPath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw 'Configuracao ausente. Execute Setup-Illustrator.ps1 e informe primeiro a versao.' }
    return Get-Content -LiteralPath $path -Raw -Encoding UTF8 | ConvertFrom-Json
}
function Get-IllustratorConnection([int]$Major,[switch]$StartIfNeeded) {
    $specific='Illustrator.Application.'+$Major; $mismatch=''
    foreach ($id in @($specific,'Illustrator.Application')) {
        try { $app=[Runtime.InteropServices.Marshal]::GetActiveObject($id) } catch { continue }
        $version=[string]$app.Version
        if ([int]($version.Split('.')[0]) -eq $Major) { return [pscustomobject]@{Application=$app;Version=$version;ProgId=$specific} }
        $mismatch=$version
    }
    if ($mismatch) { throw ('O Illustrator aberto e '+$mismatch+', diferente da versao escolhida '+$Major+'. Abra a versao escolhida antes de continuar.') }
    if (-not $StartIfNeeded) { throw ('Abra o Illustrator da versao '+$Major+' e tente novamente.') }
    if (@(Get-IllustratorRegistrations | Where-Object {$_.Major -eq $Major}).Count -eq 0) { throw ('Versao '+$Major+' nao registrada. Instale ou repare o Illustrator pelo mecanismo oficial Adobe. Este pacote nao instala o aplicativo.') }
    $app=New-Object -ComObject $specific; $version=[string]$app.Version
    if ([int]($version.Split('.')[0]) -ne $Major) { throw 'A versao aberta nao corresponde a escolhida. Nenhum documento foi editado.' }
    return [pscustomobject]@{Application=$app;Version=$version;ProgId=$specific}
}
