using namespace System.IO
using namespace System.Text.RegularExpressions
using namespace System.Windows

param(
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
    [Alias('Name', 'Game', 'App')]
    [ValidateNotNullOrEmpty()]
    [string]$AppName
)

Add-Type -AssemblyName PresentationCore, PresentationFramework

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

$steamPath = Get-SteamPath

$defaultInstallDir = Join-Path $steamPath "\steamapps\common"
$defaultInstall = Join-Path $defaultInstallDir $AppName

if (Test-Path $defaultInstall) {
    Open-Directory $defaultInstall
    return
}

$libraryConfigPath = Join-Path $steamPath "steamapps\libraryfolders.vdf"

if (!(Test-Path $libraryConfigPath)) {
    Throw "Couldn't find '$AppName' in the default install directory and no library config was found."
}

$libraryConfig = [File]::ReadAllText($libraryConfigPath)
$libraryRegex = [Regex]::new('\"path\"\t{2}\"(?<path>.+?)\"')
[MatchCollection] $matches = $libraryRegex.Matches($libraryConfig)

$id = 0

foreach ($match in $matches)
{
    $path = $match.Groups["path"].Value
    $path = [Path]::GetFullPath($path)

    $libraryPath = Join-Path $path "steamapps\common\"
    $gamePath = Join-Path $libraryPath $AppName

    $gamePath = [Path]::GetFullPath($gamePath)

    Write-Host "Checking library $id with path '$path'"...

    if (Test-Path $gamePath)
    {
        Write-Host "Found $AppName at '$gamePath'." -ForegroundColor Green

        Open-Directory $gamePath

        return
    }

    $id++
}

Throw "Unable to find the install directory of '$gameName'."
