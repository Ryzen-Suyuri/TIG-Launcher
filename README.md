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
- Get Crash Fix (prompts for patching ImpossibleGame.exe to permanently fix a common crash that occurs after ~30-45 minutes of playing a level)