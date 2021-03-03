#Persistent
#SingleInstance, force

gameId := 21690
gameName := "Resident Evil 5"
gameIcon := "resources\re5dx9.ico"

; rather than go through steam's .vdf files and search all of the library folders
; CAPCOM stores the path in their HKLM\Software reg key
GetInstallDir() {
    RegRead, InstallDir, HKEY_LOCAL_MACHINE, SOFTWARE\WOW6432Node\Capcom\RESIDENT EVIL 5, installdir
    return InstallDir
}

GetConfigFile() {
    ConfigFile = %A_MyDocuments%\CAPCOM\RESIDENT EVIL 5\config.ini
    if !FileExist(ConfigFile) {
        MsgBox, % "The " . gameName . " config file '" . ConfigFile . "' does not exist."
        return
    }
    return ConfigFile
}

; removes the standard menu items
Menu, Tray, NoStandard

Menu, Tray, Add, Launch %gameName%, LaunchGameHandler
Menu, Tray, Icon, Launch %gameName%, %gameIcon%,, 24

Menu, Tray, Add ; separator

Menu, Tray, Add, Open RE5 Config, ConfigHandler
Menu, Tray, Icon, Open RE5 Config, resources\cog.ico,, 24

Menu, Tray, Add, Open Game Directory, GameDirHandler
Menu, Tray, Icon, Open Game Directory, resources\steam_folder.ico,, 24

Menu, Tray, Add ; separator

Menu, Tray, Add, View on SteamDB, OpenSteamDBHandler
Menu, Tray, Icon, View on SteamDB, resources\steamdb.ico,, 24

Menu, Tray, Add, View on PCGW, OpenPCGWHandler
Menu, Tray, Icon, View on PCGW, resources\pcgw.ico,, 24

Menu, Tray, Add ; separator

Menu, Tray, Add, Open OBS, OBSHandler
Menu, Tray, Icon, Open OBS, resources\obs.ico,, 24

Menu, Tray, Add ; separator

; adds the standard menu items
Menu, Tray, Standard

; removes the default menu item
Menu, Tray, NoDefault

; displays a notification that the script is now running
TrayTip, %gameName% AutoHotKey Started, The %gameName% AutoHotKey (AHK) script is running. Click the tray icon for more options.,,1
SetTimer, HideTrayTip, -2000

HideTrayTip() {
    TrayTip  ; Attempt to hide it the normal way.
    if SubStr(A_OSVersion,1,3) = "10." {
        Menu Tray, NoIcon
        Sleep 200  ; It may be necessary to adjust this sleep.
        Menu Tray, Icon
    }
}

return

ConfigHandler:
    ConfigFile := GetConfigFile()
    Run, %ConfigFile%
    return

GameDirHandler:
    GameDir := GetInstallDir()
    Run, %GameDir%
    return

LaunchGameHandler:
    Run, steam://rungameid/%gameId%
    return

OpenSteamDBHandler:
    Run, https://steamdb.info/app/%gameId%/
    return

OpenPCGWHandler:
    Run, https://www.pcgamingwiki.com/api/appid.php?appid=%gameId%
    return

OBSHandler:
    Run, powershell.exe -windowstyle hidden %A_ScriptDir%\scripts\Open-OBS.ps1
    return

#IfWinActive RESIDENT EVIL 5

f::Enter   ; Makes the 'f' key send an 'Enter' key
w::Up      ; Makes the 'w' key send an 'Up' key
a::Left    ; Makes the 'a' key send a 'Left' key
s::Down    ; Makes the 's' key send a 'Down' key
d::Right   ; Makes the 'd' key send a 'Right' key

LWin::Return   ; Disables the 'Left Win' key
RWin::Return   ; Disables the 'Right Win' key

#IfWinActive
