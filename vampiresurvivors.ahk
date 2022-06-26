#Persistent
#SingleInstance, force
;#MaxHotkeysPerInterval 200
SendMode Event
SetWorkingDir, %A_ScriptDir%

; uncomment this if script keys are noticeably slower than normal
;Process, Priority, , High

; you shouldn't need to change anything below here
global AppId := 1794680
global GameName := "Vampire Survivors"
global WindowTitle := "Vampire Survivors"

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

#UseHook    ; Force the use of the hook for hotkeys after this point.

#If WinActive(WindowTitle)

$f::Space   ; Makes the 'f' key send an 'Enter' key
$Up::w      ; Makes the 'w' key send an 'Up' key
$Left::a    ; Makes the 'a' key send a 'Left' key
$Down::s    ; Makes the 's' key send a 'Down' key
$Right::d   ; Makes the 'd' key send a 'Right' key
$RCtrl::RButton

#If

^+r::Reload        ; {Ctrl + Shift + r} reloads the current script
