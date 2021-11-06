using namespace System.IO
using namespace System.Windows

Add-Type -AssemblyName PresentationFramework

Function Open-Process {
    Param(
        [string] $ExePath
    )

    $WorkingDir = Split-Path $ExePath
    $ProcName = [Path]::GetFileNameWithoutExtension($ExePath)

Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class WinApi {
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool SetForegroundWindow(IntPtr hWnd);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    }
"@

    $proc = Get-Process | where { $_.mainWindowTitle } | where { $_.Name -like $ProcName }

    if ($proc -ne $null)
    {
        $hwnd = $proc.MainWindowHandle
        [void] [WinApi]::SetForegroundWindow($hwnd)
        # https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-showwindow
        # 1 = SW_NORMAL
        [void] [WinApi]::ShowWindow($hwnd, 1)
        return
    }
    Start-Process -FilePath $ExePath -WorkingDirectory $WorkingDir
}

$OBSRegPath = Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\OBS Studio" | select -ExpandProperty "(default)"

if ([string]::IsNullOrWhiteSpace($OBSRegPath) -or !(Test-Path $OBSRegPath)) {
    $message = "Unable to find the current OBS installation path in the registry."
    $message += "`r`n`r`nWould you like to open the official OBS Studio site?"
    $response = [MessageBox]::Show($message, "OBS Path Not Found", [MessageBoxButton]::YesNo, [MessageBoxImage]::Warning)

    if ($response -eq [MessageBoxResult]::Yes) {
        Start-Process "https://obsproject.com/"
    }

    return
}

$OBSExe = gci -Path $obsPath -Recurse -File -Include obs*.exe | where { $_ -match "\\obs(?:\d{2})\.exe$" } | select -ExpandProperty FullName

Open-Process $OBSExe
