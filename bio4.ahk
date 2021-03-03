#Persistent
#SingleInstance, force

gameId := 254700
gameName := "Resident Evil 4"
gameIcon := "resources\bio4.ico"

GetConfigFile() {
    ConfigFile = %A_MyDocuments%\My Games\Capcom\RE4\config.ini
    if !FileExist(ConfigFile) {
        MsgBox, % "The " . gameName . " config file '" . ConfigFile . "' does not exist."
        return
    }
    return ConfigFile
}

GetUserInputConfigFile() {
    UsrInputConfigFile = %A_MyDocuments%\My Games\Capcom\RE4\usr_input.ini
    if !FileExist(ConfigFile) {
        MsgBox, % "The " . gameName . " input config file '" . UsrInputConfigFile . "' does not exist."
        return
    }
    return ConfigFile
}

; removes the standard menu items
Menu, Tray, NoStandard

Menu, Tray, Add, Launch %gameName%, LaunchGameHandler
Menu, Tray, Icon, Launch %gameName%, %gameIcon%,, 24

Menu, Tray, Add ; separator

Menu, Tray, Add, Open %gameName% Config, ConfigHandler
Menu, Tray, Icon, Open %gameName% Config, resources\cog.ico,, 24

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

OBSHandler:
    Run, powershell.exe -windowstyle hidden %A_ScriptDir%\scripts\Open-OBS.ps1
    return

LaunchGameHandler:
    Run, steam://rungameid/%gameId%
    return

OpenPCGWHandler:
    Run, https://www.pcgamingwiki.com/api/appid.php?appid=%gameId%
    return

OpenSteamDBHandler:
    Run, https://steamdb.info/app/%gameId%/
    return

#IfWinActive Resident Evil 4

; WARN:
;   the 'f' key by default is the 'Ashley' key,
;   so rebinding it here means you need to rebind that action
;   otherwise the 'Ashley' commands will not work
f::Enter   ; Makes the 'f' key send an 'Enter' key

LWin::Return   ; Disables the 'Left Win' key
RWin::Return   ; Disables the 'Right Win' key

#IfWinActive
