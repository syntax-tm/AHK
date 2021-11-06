#Persistent
#SingleInstance, force
SendMode Input
SetWorkingDir, %A_ScriptDir%

; uncomment this if script keys are noticeably slower than normal
;Process, Priority, , High

; hotkey customizations (true = enabled, false = disabled)
global DisableWinKeys     := true

; you shouldn't need to change anything below here
global AppId := 221040
global GameName := "Resident Evil 6"

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
    global ConfigFile := Format("{1}\CAPCOM\RESIDENT EVIL 6\config.ini", A_MyDocuments)
    if !FileExist(ConfigFile) {
        MsgBox, 48, % GameName . " Config File Missing", % "The " . GameName . " config file '" . ConfigFile . "' does not exist."
        return
    }
    Run, %ConfigFile%
    return

InputConfigHandler:
    global UsrInputConfigFile := Format("{1}\CAPCOM\RESIDENT EVIL 6\mapping.ini", A_MyDocuments)
    if !FileExist(UsrInputConfigFile) {
        MsgBox, 48, % GameName . " Input Config File Missing", % "The " . GameName . " input config file '" . UsrInputConfigFile . "' does not exist."
        return
    }
    Run, %UsrInputConfigFile%
    return

#IfWinActive RESIDENT EVIL 6

w::Up      ; Makes the 'w' key send an 'Up' key
a::Left    ; Makes the 'a' key send a 'Left' key
s::Down    ; Makes the 's' key send a 'Down' key
d::Right   ; Makes the 'd' key send a 'Right' key

LShift::Space  ; Makes the 'Left Shift' key send a 'Space' key

if (DisableWinKeys)
{
    LWin::Return   ; Disables the 'Left Win' key
    RWin::Return   ; Disables the 'Right Win' key
}

#IfWinActive

^+r::Reload        ; {Ctrl + Shift + r} reloads the current script
