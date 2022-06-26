DirectoryExists(Path)
{
    return InStr(FileExist(Path), "D") > 0
}

IsDirectory(Path)
{
    FileGetAttrib, PathAttribs, %Path%
    return InStr(PathAttribs, "D") > 0
}

IsDirectoryEmpty(FullPath)
{
    if !DirectoryExists(FullPath)
    {
        return False
    }

    Loop Files, %FullPath%\*.*, F  ; Recurse into subfolders.
    {
        return True
    }

    return False
}

global LaunchGame := Func("LaunchSteamApp").Bind(AppId)
global ViewGameFiles := Func("BrowseGameFiles").Bind(AppId)
global ViewSaveFiles := Func("SaveDirHandler").Bind(AppId)

global OBS := Func("LaunchOBS")
global SteamStore := Func("ViewOnSteamStore")
global SteamCommunity := Func("ViewSteamCommunity")
global SteamCommunityGuides := Func("ViewSteamCommunityGuides")
global SteamDB := Func("ViewOnSteamDB").Bind(AppId)
global PCGW := Func("ViewOnPCGW").Bind(AppId)

ShowNotification(Name)
{
    ; displays a notification that the script is now running
    TrayTip, %A_ScriptName% AutoHotKey Started, The %Name% AutoHotKey (AHK) script is running. Click the tray icon for more options.,,49
    SetTimer, HideTrayTip, -5000
}

HideTrayTip()
{
    ; Attempt to hide it the normal way
    TrayTip
    if SubStr(A_OSVersion,1,3) = "10." {
        Menu Tray, NoIcon
        Sleep 200
        Menu Tray, Icon
    }
}

RemoveStandardMenuItems()
{
    Menu, Tray, NoStandard ; removes the standard menu items
}

AddChildAhkItems(FullPath)
{
    if !DirectoryExists(FullPath)
        return

    FileList := ""

    Loop, Files, %FullPath%\*.ahk, F
    {
        FileList .= A_LoopFileLongPath "`n"
    }

    Sort, FileList

    Loop, Parse, FileList, `n
    {
        if (A_LoopField = "")
            continue

        SplitPath, A_LoopField,,,, LoopItemNameNoExt

        AHKHandler := Func("LaunchAHK").Bind(A_LoopField)

        Menu, AHK, Add, %LoopItemNameNoExt%, % AHKHandler
        Menu, AHK, Icon, %LoopItemNameNoExt%, %A_AhkPath%, 1
    }

    Menu, Tray, Add, AHK Scripts, :AHK
    Menu, Tray, Icon, AHK Scripts, %A_AhkPath%, 1
}

AddToolMenuItems()
{
    ToolMenuCreated := false
    ToolsDir := Format("{1}\tools", A_WorkingDir)
    if !DirectoryExists(ToolsDir) {
        FileCreateDir, %ToolsDir%
        return
    }

    FileList := ""
    RootFileList := ""

    Loop, Files, %ToolsDir%\*.*, FDR
    {
        isDirectory := IsDirectory(A_LoopFileFullPath)
        isRoot := A_LoopFileDir = ToolsDir
        isRootFile := !isDirectory and isRoot
        isSubDir := isDirectory and !isRoot

        FileList .= isDirectory "`t" !isSubDir "`t" A_LoopFileDir "`t" A_LoopFileLongPath "`n"
    }

    Sort, FileList

    Loop, Parse, FileList, `n
    {
        if (A_LoopField = "")
            continue

        StringSplit, FileItem, A_LoopField, %A_Tab%

        isDirectory := FileItem1

        SplitPath, FileItem4, LoopItemName, LoopItemDir, LoopItemExt, LoopItemNameNoExt, LoopItemDrive
        SplitPath, LoopItemDir, ParentDirectoryName

        ToolHandler := Func("LaunchTool").Bind(A_LoopField)

        if (ParentDirectoryName = "tools" and !isDirectory)
        {
            RootFileList .= FileItem4 "`n"
        }
        else If isDirectory
        {
            Menu, %ParentDirectoryName%, Add, %LoopItemNameNoExt%, :%LoopItemNameNoExt%
            Menu, %ParentDirectoryName%, Icon, %LoopItemNameNoExt%, imageres.dll, -190
        }
        Else
        {
            AddMenuItem(FileItem4)
        }

        ToolMenuCreated := true
    }

    Sort, RootFileList

    Loop, Parse, RootFileList, `n
    {
        if (A_LoopField = "")
            continue

        AddMenuItem(A_LoopField)

        ToolMenuCreated := true
    }

    if !ToolMenuCreated
    {
        return
    }

    Menu, Tray, Add, Tools, :Tools
    Menu, Tray, Icon, Tools, imageres.dll, -197
}

AddMenuItem(Path)
{
    SplitPath, Path, LoopItemName, LoopItemDir, LoopItemExt, LoopItemNameNoExt, LoopItemDrive
    SplitPath, LoopItemDir, ParentDirectoryName

    ToolHandler := Func("LaunchTool").Bind(Path)

    Menu, %ParentDirectoryName%, Add, %LoopItemNameNoExt%, % ToolHandler

    if (LoopItemExt = "lnk")
    {
        FileGetShortcut, %Path%, OutLocation, OutDir, OutArgs, OutDescription, OutIcon, OutIconNum, OutRunState
        Menu, %ParentDirectoryName%, Icon, %LoopItemNameNoExt%, %OutLocation%, 1
    }
    else if (LoopItemExt = "exe")
    {
        Menu, %ParentDirectoryName%, Icon, %LoopItemNameNoExt%, %Path%, 1
    }
    else if (LoopItemExt = "ahk")
    {
        Menu, %ParentDirectoryName%, Icon, %LoopItemNameNoExt%, %A_AhkPath%, 1
    }
}

AddMenu(MenuName) ; Attach submenu to next level
{
    SplitPath, MenuName, DirName, OutDir
    Menu, %OutDir%, Add, %DirName%, :%MenuName%
    Menu, %OutDir%, Icon, %DirName%, imageres.dll, -10
}

AddGameTrayMenuItems()
{
    Menu, Tray, Add, Launch %GameName%, % LaunchGame
    Menu, Tray, Icon, Launch %GameName%, setupapi.dll, -40

    Menu, Tray, Add          ; separator

    Menu, EditMenu, Add, Open Game Directory, % ViewGameFiles
    Menu, EditMenu, Icon, Open Game Directory, imageres.dll, -10
    Menu, EditMenu, Add, Open Save Directory, % ViewSaveFiles
    Menu, EditMenu, Icon, Open Save Directory, shell32.dll, -16761
    Menu, Tray, Add, &Edit, :EditMenu
    Menu, Tray, Icon, &Edit, Shell32.dll, -16826

    Menu, ResourcesMenu, Add, View on Steam Store, % SteamStore
    Menu, ResourcesMenu, Icon, View on Steam Store, shell32.dll, -303
    Menu, ResourcesMenu, Add, View Community, % SteamCommunity
    Menu, ResourcesMenu, Icon, View Community, imageres.dll, -79
    Menu, ResourcesMenu, Add, View Community Guides, % SteamCommunityGuides
    Menu, ResourcesMenu, Icon, View Community Guides, imageres.dll, -5350
    Menu, ResourcesMenu, Add  ; separator
    Menu, ResourcesMenu, Add, View on SteamDB, % SteamDB
    Menu, ResourcesMenu, Icon, View on SteamDB, imageres.dll, -8
    Menu, ResourcesMenu, Add, View on PCGW, % PCGW
    Menu, ResourcesMenu, Icon, View on PCGW, imageres.dll, -25
    Menu, Tray, Add, &Resources, :ResourcesMenu
    Menu, Tray, Icon, &Resources, imageres.dll, -81
}

AddStandardTrayMenuItems()
{
    Menu, Tray, Add          ; separator
    Menu, Tray, Standard     ; adds the standard menu items
    Menu, Tray, NoDefault    ; removes the default menu item
}

BrowseGameFiles()
{
    static findInstallScriptExists := FileExist("scripts\Open-GameDirectory.ps1")
    if (findInstallScriptExists) {
        command := Format("{1}{2}{3} {4}", "Set-ExecutionPolicy Bypass -Scope Process -Force;", A_ScriptDir, "\scripts\Open-GameDirectory.ps1 ", AppId)
        Run, powershell.exe -windowstyle hidden %command%
    }
}

SaveDirHandler()
{
    static openUserDataScriptExists := FileExist("scripts\Open-SteamUserData.ps1")
    if (openUserDataScriptExists) {
        command := Format("{1}{2}{3} {4}", "Set-ExecutionPolicy Bypass -Scope Process -Force;", A_ScriptDir, "\scripts\Open-SteamUserData.ps1 ", AppId)
        Run, powershell.exe -windowstyle hidden %command%
    }
}

LaunchSteamApp() {
    Run, steam://rungameid/%AppId%
}

ViewOnSteamStore() {
    Run, https://store.steampowered.com/app/%AppId%/
}

ViewSteamCommunity() {
    Run, https://steamcommunity.com/app/%AppId%
}

ViewSteamCommunityGuides() {
    Run, https://steamcommunity.com/app/%AppId%/guides
}

ViewOnSteamDB() {
    Run, https://steamdb.info/app/%AppId%/
}

ViewOnPCGW() {
    Run, https://www.pcgamingwiki.com/api/appid.php?appid=%AppId%
}

LaunchOBS()
{
    static obsScript := Format("{1}\scripts\Open-OBS.ps1", A_WorkingDir)
    static obsScriptExists := FileExist(obsScript)
    if (obsScriptExists) {
        Run, powershell.exe -windowstyle hidden %obsScript%
    }
}

LaunchAHK(AHKScriptPath)
{
    SplitPath, AHKScriptPath,, AHKScriptDirectory
    Run, %AHKScriptPath%, %AHKScriptDirectory%
}

LaunchTool(ToolPath)
{
    Run, %ToolPath%
}
