#Persistent
#SingleInstance, force
SendMode Input
SetWorkingDir, %A_ScriptDir%

; uncomment this if script keys are noticeably slower than normal
;Process, Priority, , High

; hotkey customizations (true = enabled, false = disabled)
global DisableWinKeys     := true
global AppId              := 254700
global GameName           := "Back 4 Blood"

; import the shared script functions after we declared the AppId and GameName
#Include, scripts/ahk_shared.ahk

RemoveStandardMenuItems()

AddGameTrayMenuItems()

Menu, EditMenu, Add

AddToolMenuItems()

AddStandardTrayMenuItems()

ShowNotification(GameName)

return

#IfWinActive Back 4 Blood

g::3   ; Makes the 'g' key send a '3' key (grenades)
;tab::i ; Makes the 'tab' key send an 'i' key (toggle inventory)

#IfWinActive

^+r::Reload        ; {Ctrl + Shift + r} reloads the current script
