using namespace System.IO
using namespace System.Text.RegularExpressions

Add-Type -AssemblyName PresentationFramework

$scriptName = Split-Path $PSCommandPath -Leaf

if ($args.Count -lt 1) {
    Write-Host "No arguments passed to '$scriptName'."
    return
}

Function Open-Directory([string] $dir)
{
    Start-Process explorer.exe "$dir"
}

Function Get-SteamPath
{
    $steamInstallPath = Get-ItemProperty "HKCU:\Software\Valve\Steam" | Select-Object -ExpandProperty "SteamPath"

    if ([string]::IsNullOrEmpty($steamInstallPath)) {
        Throw "Unable to determine the Steam install location."
    }

    return $steamInstallPath
}

Function Get-SteamUserID
{
    $userId = Get-ItemProperty "HKCU:\Software\Valve\Steam\ActiveProcess" | Select-Object -ExpandProperty "ActiveUser"
    return $userId
}

$gameId = $args[0]
$steamPath = Get-SteamPath
$userId = Get-SteamUserID

if ($userId -ne $null -and $userId -ne 0)
{
    $gameDataDir = Join-Path $steamPath "\userdata" $userId $gameId
    if (Test-Path $gameDataDir) {
        Open-Directory $gameDataDir
        return
    }
}

$message = "An error occurred attempting to open the user data for game '$gameId'. Please verify that Steam is "
$message += "running and that you are signed in and try again."

[MessageBox]::Show($message, "Unable to Open User Data", [MessageBoxButton]::OK, [MessageBoxImage]::Warning)
