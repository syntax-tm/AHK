#Persistent
#SingleInstance, force

gameId := 221040
gameName := "Resident Evil 6"
gameIcon := "resources\bh6.ico"

GetConfigFile() {
    ConfigFile = %A_MyDocuments%\CAPCOM\RESIDENT EVIL 6\config.ini
    if !FileExist(ConfigFile) {
        MsgBox, % "The " . gameName . " config file '" . ConfigFile . "' does not exist."
        return
    }
    return ConfigFile
}

GetUserInputConfigFile() {
    UsrInputConfigFile = %A_MyDocuments%\CAPCOM\RESIDENT EVIL 6\mapping.ini
    if !FileExist(UsrInputConfigFile) {
        MsgBox, % "The " . gameName . " input config file '" . UsrInputConfigFile . "' does not exist."
        return
    }
    return UsrInputConfigFile
}

; removes the standard menu items
Menu, Tray, NoStandard

Menu, Tray, Add, Launch %gameName%, LaunchGameHandler
Menu, Tray, Icon, Launch %gameName%, %gameIcon%,, 24

Menu, Tray, Add ; separator

Menu, Tray, Add, Open RE6 Config, ConfigHandler
Menu, Tray, Icon, Open RE6 Config, resources\cog.ico,, 24

Menu, Tray, Add, Open %gameName% Input Config, InputConfigHandler
Menu, Tray, Icon, Open %gameName% Input Config, resources\keyboard.ico,, 24

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

InputConfigHandler:
    InputConfigFile := GetUserInputConfigFile()
    Run, %InputConfigFile%
    return

GameDirHandler:
    Run, powershell.exe -windowstyle hidden %A_ScriptDir%\scripts\Open-GameDirectory.ps1 '%gameName%'
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

#IfWinActive RESIDENT EVIL 6

w::Up      ; Makes the 'w' key send an 'Up' key
a::Left    ; Makes the 'a' key send a 'Left' key
s::Down    ; Makes the 's' key send a 'Down' key
d::Right   ; Makes the 'd' key send a 'Right' key

LShift::Space  ; Makes the 'Left Shift' key send a 'Space' key

LWin::Return   ; Disables the 'Left Win' key
RWin::Return   ; Disables the 'Right Win' key

#IfWinActive
