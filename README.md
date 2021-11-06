# AutoHotKey Scripts

A collection of my AutoHotKey scripts that I use with various games/applications.

## Features

- Startup notification
- Customized Tray menu (see below)
- Disable Windows keys while in-game
- Key bindings only active while in-game

### Tray Menu

All of the `*.ahk` scripts add the following items to the Tray menu:

- Launch Game
- Edit Menu
  - Open Game Directory
  - Open Save Directory
  - Edit Game Config
  - Edit Input Config
    - _If available_
- Resources Menu
  - View on [Steam Store](https://store.steampowered.com)
  - View on [Steam Community](http://steamcommunity.com/)
  - View Guides on [Steam Community](https://steamcommunity.com/?subsection=guides)
  - View on [SteamDB](https://www.steamdb.info)
  - View on [PC Gaming Wiki](https://www.pcgamingwiki.com)
- Tools Menu
  - _User-defined application shortcuts_

### Tools Menu

At startup, any files contained in the `tools` directory will be added to the tray menu. This not only supports `*.lnk` files, including their target's icons, and `*.exe`, again with icons support, but any other file as well.

Supports folders for organization but only one deep. So, `\tools\Streaming` would put everything in the `Streaming` folder under `Tools > Streaming` but `\tools\Streaming\BadExample` would not work.

## AutoHotKey Scripts (*.ahk)

### bio4.ahk

Script for **Resident Evil 4**. Disables the Windows keys and rebinds the `f` key to `Enter` only active when the game's window is active.

```AutoHotKey
f::Enter   ; Makes the 'f' key send an 'Enter' key
```

#### Warning

The `f` key by default is the '_Ashley_' key in **Resident Evil 4** so rebinding it here means that you will need rebind that action otherwise the '_Ashley_' commands will not work.

### re5dx9.ahk

Script for **Resident Evil 5**. Only active when the game's window is active.

```AutoHotKey
f::Enter   ; Makes the 'f' key send an 'Enter' key
w::Up      ; Makes the 'w' key send an 'Up' key
a::Left    ; Makes the 'a' key send a 'Left' key
s::Down    ; Makes the 's' key send a 'Down' key
d::Right   ; Makes the 'd' key send a 'Right' key
```

By binding the `WASD` keys to the movement keys you can navigate menus (including inventory in-game) using `WASD` with `f` functioning as the `ENTER` key.

You will need to rebind your movement keys in-game to use the arrow keys for this to work. It will also show QTE (Quick-Time Events) with the arrow keys, so just keep that in mind. Unfortunately, RE5 only supports one key binding per action so you can't have an alternate key (like in Revelations 2).

By default, the script will also block the `Shift`+`RMouse` shotcut to reload your weapon. You can disable this by setting the `DisableShiftReload` to `False` (default is `True`).

### re6.ahk

Script for **Resident Evil 6**. Similar to the RE5 one, it rebinds the `WASD` keys to the movement arrows and is only active when the game's window is active.

```AutoHotKey
w::Up      ; Makes the 'w' key send an 'Up' key
a::Left    ; Makes the 'a' key send a 'Left' key
s::Down    ; Makes the 's' key send a 'Down' key
d::Right   ; Makes the 'd' key send a 'Right' key
LShift::Space  ; Makes the 'Left Shift' key send a 'Space' key
```

By binding the `WASD` keys to the movement keys you can navigate menus (including inventory in-game) using `WASD` with `f` functioning as the `ENTER` key.

## Powershell Scripts

### Open-GameDirectory.ps1

Finds the installation directory for an installed game. Will check the registry to get the default `InstallPath` for Steam and check the the `steamapps\common` directory. If it can't find the install in the default location it will check all of the library locations in the `steamapps\libraryfolders.vdf` config file. Once it finds the install directory, it will open it in File Explorer.

### Open-OBS.ps1

Finds the OBS path in the registry and then searches for the `OBS{32|64}.exe` file. If OBS is already running, it will activate it using the Win32 API. If OBS is not already running it will start it.

## TODO

- [ ] Add ToolTips to the Tray menu items
- [ ] Move reusable code into its own script
- [ ] Add ability to configure menu items
- [ ] Add SteamDB to the Tray menu
- [ ] Add Steam Store to the Tray menu
- [ ] Add launch Steam to the Tray menu

## Image Resources

- [PCGW icons](https://www.pcgamingwiki.com/wiki/PCGamingWiki:Icons)
- [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/)
