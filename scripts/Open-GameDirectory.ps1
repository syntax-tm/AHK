using namespace System.IO
using namespace System.Text.RegularExpressions

if ($args.Count -lt 1)
{
    Write-Host "No arguments passed to Open-GameDirectory."
    return
}

Function Open-Directory([string] $dir)
{
    Start-Process explorer.exe "$dir"
}

Function Get-SteamPath
{
    $steamInstallPath = Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Valve\Steam" | Select-Object -ExpandProperty "InstallPath"

    if ([string]::IsNullOrEmpty($steamInstallPath)) {
        Throw "Unable to determine the Steam install location."
    }

    return $steamInstallPath
}

$gameName = $args[0]
$steamPath = Get-SteamPath

$defaultInstallDir = Join-Path $steamPath "\steamapps\common"
$defaultInstall = Join-Path $defaultInstallDir $gameName

if (Test-Path $defaultInstall) {
    Open-Directory $defaultInstall
    return
}

$libraryConfigPath = Join-Path $steamPath "steamapps\libraryfolders.vdf"

if (!(Test-Path $libraryConfigPath)) {
    Throw "Couldn't find '$gameName' in the default install directory and no library config was found."
}

$libraryConfig = [File]::ReadAllText($libraryConfigPath)
$libraryRegex = New-Object Regex('\"(?<id>[0-9]+)\"\t{2}\"(?<path>.+)\"')    
[MatchCollection] $matches = $libraryRegex.Matches($libraryConfig)

foreach ($match in $matches)
{
    $id = $match.Groups["id"].Value
    $path = $match.Groups["path"].Value

    Write-Host "Checking library $id with path '$path'"...

    $libraryPath = Join-path $path "steamapps\common\"
    $gamePath = Join-Path $libraryPath $gameName

    $gamePath = [Path]::GetFullPath($gamePath)

    if (Test-Path $gamePath)
    {
        Write-Host "Found $gameName at '$gamePath'."

        Open-Directory $gamePath
        return
    }
}

Throw "Unable to find the install directory of '$gameName'."
