#Persistent
#SingleInstance, force
SendMode Input
SetWorkingDir, %A_ScriptDir%

; uncomment this if script keys are noticeably slower than normal
;Process, Priority, , High

; hotkey customizations (true = enabled, false = disabled)
global DisableShiftReload := true
global DisableWinKeys     := true

; you shouldn't need to change anything below here
global AppId := 21690
global GameName := "Resident Evil 5"

; import the shared script functions after we declared the AppId and GameName
#Include, scripts/ahk_shared.ahk

RemoveStandardMenuItems()

AddGameTrayMenuItems()

AddToolMenuItems()

Menu, EditMenu, Add

Menu, EditMenu, Add, Edit RE5 Config, ConfigHandler
Menu, EditMenu, Icon, Edit RE5 Config, imageres.dll, 63

AddStandardTrayMenuItems()

ShowNotification(GameName)

return

ConfigHandler:
    ConfigFile = Format("{1}\CAPCOM\RESIDENT EVIL 5\config.ini", A_MyDocuments)
    if !FileExist(ConfigFile) {
        MsgBox, 48, % GameName . " Config File Missing", % "The " . GameName . " config file '" . ConfigFile . "' does not exist."
        return
    }
    Run, %ConfigFile%
    return

#IfWinActive RESIDENT EVIL 5

f::Enter   ; Makes the 'f' key send an 'Enter' key
w::Up      ; Makes the 'w' key send an 'Up' key
a::Left    ; Makes the 'a' key send a 'Left' key
s::Down    ; Makes the 's' key send a 'Down' key
d::Right   ; Makes the 'd' key send a 'Right' key

if (DisableShiftReload)
{
    $RButton::RButton         ; Disables reloading when pressing shift
    RButton & ~Shift::Return ; while right mouse is down (aiming)
}

if (DisableWinKeys)
{
    LWin::Return   ; Disables the 'Left Win' key
    RWin::Return   ; Disables the 'Right Win' key
}

#IfWinActive

^+r::Reload        ; {Ctrl + Shift + r} reloads the current script
