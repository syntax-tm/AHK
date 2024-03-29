#Persistent
#SingleInstance, force
#MaxHotkeysPerInterval 200
SendMode Event
SetWorkingDir, %A_ScriptDir%

; uncomment this if script keys are noticeably slower than normal
;Process, Priority, , High

; hotkey customizations (true = enabled, false = disabled)
global DisableShiftReload := true
global DisableWinKeys     := false

; you shouldn't need to change anything below here
global AppId := 21690
global GameName := "Resident Evil 5"

; import the shared script functions after we declared the AppId and GameName
#Include, scripts/ahk_shared.ahk

Try
{
    RemoveStandardMenuItems()

    AddGameTrayMenuItems()

    AddToolMenuItems()

    Menu, EditMenu, Add

    Menu, EditMenu, Add, Edit RE5 Config, ConfigHandler
    Menu, EditMenu, Icon, Edit RE5 Config, imageres.dll, 63
}
Finally
{
    AddStandardTrayMenuItems()

    ShowNotification(GameName)
}

return

ConfigHandler:
    MsgBox, % A_MyDocuments
    ConfigFile = %A_MyDocuments%\CAPCOM\RESIDENT EVIL 5\config.ini
    if !FileExist(ConfigFile) {
        MsgBox, 48, % GameName . " Config File Missing", % "The " . GameName . " config file '" . ConfigFile . "' does not exist."
        return
    }
    Run, %ConfigFile%
    return

DoNothing:
    return

#IfWinActive RESIDENT EVIL 5

~f::Enter   ; Makes the 'f' key send an 'Enter' key
~w::Up      ; Makes the 'w' key send an 'Up' key
~a::Left    ; Makes the 'a' key send a 'Left' key
~s::Down    ; Makes the 's' key send a 'Down' key
~d::Right   ; Makes the 'd' key send a 'Right' key

HotKey, RButton & Shift, DoNothing
HotKey, Shift & RButton, DoNothing

if (DisableWinKeys)
{
    LWin::Return   ; Disables the 'Left Win' key
    RWin::Return   ; Disables the 'Right Win' key
}

#IfWinActive

^+r::Reload        ; {Ctrl + Shift + r} reloads the current script
