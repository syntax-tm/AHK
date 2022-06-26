#Persistent
#SingleInstance, force
;#MaxHotkeysPerInterval 200
SendMode Event
SetWorkingDir, %A_ScriptDir%

SleepTime := 10

SetWinDelay, 0
SetTitleMatchMode, 3
;SetTitleMatchMode, slow
DetectHiddenWindows, On

; uncomment this if script keys are noticeably slower than normal
;Process, Priority, , High

; you shouldn't need to change anything below here
global AppId := 0
global GameName := "Solitaire"
global WindowTitle := "Solitaire"

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

WinGetActiveTitle() {
	WinGetActiveTitle, v
	Return, v
}

return

#IfWinNotActive Solitaire

f3::
    if InStr(WinGetActiveTitle(), "New Game")
    {
        MsgBox, "No."
    }
    if WinGetActiveTitle() contains Lost,Won
    {
        MsgBox, "Game won/lost."
    }
    return

f4::
    MsgBox % "The active window's ID is " WinExist("A")
    return
f5::
    WinGetActiveTitle, h_title
    MsgBox, The active window is "%h_title%".
    return

f6::
    WinGetClass, h_class, A
    MsgBox, The active window class is "%h_class%".
    return

f7::
    ControlGetFocus, ActiveCtrl, A
    MsgBox, The current active Control is "%ActiveCtrl%".
    return

#IfWinActive Solitaire

f3::
    Sleep 0
    Send {h down}
    Send {h up}
    ;Sleep 5
    Sleep 0
    Send {Enter down}
    Send {Enter up}
    Sleep 0
    return

#IfWinActive

^+r::Reload        ; {Ctrl + Shift + r} reloads the current script
