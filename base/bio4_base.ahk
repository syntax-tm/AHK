#Persistent
#SingleInstance, force
SendMode Input
SetWorkingDir, %A_ScriptDir%

; uncomment this if script keys are noticeably slower than normal
;Process, Priority, , High

; hotkey customizations (true = enabled, false = disabled)
global DisableWinKeys     := true

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
