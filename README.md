# TIG-Launcher

Launcher, toolkit, and memory patcher for various cheats and utilities for The Impossible Game

Made with retro love in Visual Basic 6, compatible with Windows 2000-11

## Usage

### Memory Patches (Checkboxes)

In the launcher's main window, there are various checkboxes corresponding to the available memory patches:
- Practice Mode Music (changes generic practice music to the current level's song, also syncing/restarting with the level)
- Noclip (disables all death triggers, but allows collision with blocks)
- Disable Death Effect (disables death explosion/particle effect)
- Track Total Attempts Per Level (counts all attempts on any level played, storing each total in attempts.txt)

When checked, the patch is applied in memory, and when unchecked, the patch is revoked. ImpossibleGame.exe must be running at the moment a checkbox is clicked in order for the specified patch to apply.

### Other Tools (Buttons)

There are four action buttons at the bottom of the main window, each launching another window or tool:
- Editor Tools (launches TIGUnusedInserter.exe, a command-line tool that allows for adding hidden/unused features, e.g. gravity changes, to a level)
- Credits (shows credits to all that assisted in the launcher's creation)
- Level BG Importer (allows importing custom in-game backgrounds/assets)
- Get Crash Fix (prompts for patching ImpossibleGame.exe to permanently fix a common crash that occurs after ~30-45 minutes of playing a level; saves the original executable as ImpossibleGame.exe.og)

#### Editor Tools

To find an X position at which to insert an unused effect, open the original Impossible Game level editor, insert a mark around the desired area to place the effect, click "Play from mark," and pause when the moving mark reaches the desired position. This will show a position number in the top-left corner of the editor that can now be copied into the inserter tool. It is worth noting that effects seem to take effect about a second or two after the indicated X position, and gravity changes work best when there are no blocks on-screen.

Note: Rising block effects added to a level with Editor Tools may not take effect. It is unknown how/why this happens, but the only known working instance is in [Heaven](https://github.com/MysticAx0lotl/impossible-game-levels/blob/main/output/heaven.lvl/level.dat), where the start and end X positions of the effect are the same.

## Special Thanks

- [libImpossibleLevel](https://github.com/MysticAx0lotl/impossible-game-levels) by MysticAx0lotl (C++ library for Impossible Game level editing)