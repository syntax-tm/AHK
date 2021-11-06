#Persistent
#SingleInstance, force
SendMode Input
SetWorkingDir, %A_ScriptDir%

; uncomment this if script keys are noticeably slower than normal
;Process, Priority, , High

; hotkey customizations (true = enabled, false = disabled)
global DisableWinKeys     := true

global AppId := 254700
global GameName := "Resident Evil 4"

; import the shared script functions after we declared the AppId and GameName
#Include, scripts/ahk_shared.ahk

RemoveStandardMenuItems()

AddGameTrayMenuItems()

Menu, EditMenu, Add

Menu, EditMenu, Add, &Edit Config, ConfigHandler
Menu, EditMenu, Icon, &Edit Config, imageres.dll, 63

Menu, EditMenu, Add, Edit &Input Config, InputConfigHandler
Menu, EditMenu, Icon, Edit &Input Config, setupapi.dll, -40

AddToolMenuItems()

AddStandardTrayMenuItems()

ShowNotification(GameName)

return

ConfigHandler:
    global ConfigFile = Format("{1}\My Games\Capcom\RE4\config.ini", A_MyDocuments)
    if !FileExist(ConfigFile) {
        MsgBox, 48, % GameName . " Config File Missing", % "The " . GameName . " config file '" . ConfigFile . "' does not exist."
        return
    }
    Run, %ConfigFile%
    return

InputConfigHandler:
    global UsrInputConfigFile := Format("{1}\My Games\Capcom\RE4\usr_input.ini", A_MyDocuments)
    if !FileExist(UsrInputConfigFile) {
        MsgBox, 48, % GameName . " Input Config File Missing", % "The " . GameName . " input config file '" . UsrInputConfigFile . "' does not exist."
        return
    }
    Run, %UsrInputConfigFile%
    return

#IfWinActive Resident Evil 4

; WARN:
;   the 'f' key by default is the 'Ashley' key,
;   so rebinding it here means you need to rebind that action
;   otherwise the 'Ashley' commands will not work
f::Enter   ; Makes the 'f' key send an 'Enter' key

if (DisableWinKeys)
{
    LWin::Return   ; Disables the 'Left Win' key
    RWin::Return   ; Disables the 'Right Win' key
}

#IfWinActive

^+r::Reload        ; {Ctrl + Shift + r} reloads the current script
