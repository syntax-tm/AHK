#Persistent
#SingleInstance, force
#MaxHotkeysPerInterval 200
SendMode Event
SetWorkingDir, %A_ScriptDir%

; uncomment this if script keys are noticeably slower than normal
;Process, Priority, , High

; hotkey customizations (true = enabled, false = disabled)
global DisableWinKeys     := false

; you shouldn't need to change anything below here
global AppId := 292730
global GameName := "Call of Duty: Infinite Warfare"

; import the shared script functions after we declared the AppId and GameName
#Include, scripts/ahk_shared.ahk

Try
{
    RemoveStandardMenuItems()

    AddGameTrayMenuItems()

    AddToolMenuItems()
}
Finally
{
    AddStandardTrayMenuItems()

    ShowNotification(GameName)
}

return

ConfigHandler:
    return

#IfWinActive Call of Duty® Infinite Warfare

~f::Enter   ; Makes the 'f' key send an 'Enter' key
~w::Up      ; Makes the 'w' key send an 'Up' key
~a::Left    ; Makes the 'a' key send a 'Left' key
~s::Down    ; Makes the 's' key send a 'Down' key
~d::Right   ; Makes the 'd' key send a 'Right' key

if (DisableWinKeys)
{
    LWin::Return   ; Disables the 'Left Win' key
    RWin::Return   ; Disables the 'Right Win' key
}

#IfWinActive

^+r::Reload        ; {Ctrl + Shift + r} reloads the current script
