using namespace System.IO
using namespace System.Text.RegularExpressions
using namespace System.Windows

param(
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
    [Alias('App', 'Id')]
    [uint32]$AppId
)

Add-Type -AssemblyName PresentationCore, PresentationFramework

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

$steamPath = Get-SteamPath
$userId = Get-SteamUserID

if ($null -ne $userId -and $userId -ne 0)
{
    $gameDataDir = Join-Path $steamPath "userdata\$userId\$AppId\remote"

    #$gameDataDir = [Path]::Join($steamPath, "userdata", $userId, $AppId, "remote")
    #$gameDataDir = Join-Path -Path $steamPath, "userdata", $userId, $AppId -ChildPath "remote"
    if (Test-Path $gameDataDir) {
        Open-Directory $gameDataDir
        return
    }
}

$message = "An error occurred attempting to open the user data for app id '$AppId'. Please verify that Steam is "
$message += "running and that you are signed in and try again."

[MessageBox]::Show($message, "Unable to Open User Data", [MessageBoxButton]::OK, [MessageBoxImage]::Warning)
