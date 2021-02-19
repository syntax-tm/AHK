Function Open-Process {
    Param(
        [string] $proc,
        [string] $adm
    )
    Clear-Host

Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class WinAp {
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool SetForegroundWindow(IntPtr hWnd);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    }
"@

    $p = Get-Process | where { $_.mainWindowTitle } |
        where { $_.Name -like "$proc" }
    if (($p -eq $null) -and ($adm -ne "")) {
        Start-Process "$proc" -Verb runAs
    }
    elseif (($p -eq $null) -and ($adm -eq "")) {
        Start-Process "$proc"
    }
    else {
        $h = $p.MainWindowHandle
        [void] [WinAp]::SetForegroundWindow($h)
        [void] [WinAp]::ShowWindow($h, 3)
    }
}

$obsPath = Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\OBS Studio" | Select-Object -ExpandProperty "(default)"
$obsExe = Get-ChildItem -Path $obsPath -Recurse -File -Include obs*.exe | Where-Object -FilterScript { $_ -match "\\obs(\d{2})\.exe$" }

Set-Location (Split-Path $obsExe)

Open-Process $obsExe.FullName
