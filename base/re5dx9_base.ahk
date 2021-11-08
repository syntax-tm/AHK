#Persistent
#SingleInstance, force
SendMode Input
SetWorkingDir, %A_ScriptDir%

; uncomment this if script keys are noticeably slower than normal
;Process, Priority, , High

#IfWinActive RESIDENT EVIL 5

f::Enter   ; Makes the 'f' key send an 'Enter' key
w::Up      ; Makes the 'w' key send an 'Up' key
a::Left    ; Makes the 'a' key send a 'Left' key
s::Down    ; Makes the 's' key send a 'Down' key
d::Right   ; Makes the 'd' key send a 'Right' key

LWin::Return   ; Disables the 'Left Win' key
RWin::Return   ; Disables the 'Right Win' key

#IfWinActive
