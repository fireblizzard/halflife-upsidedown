# Half-Life Upside Down mod
Upside Down mod for Half-Life 1 based on the Kill Counter mod. Not tested on Linux yet

Adds a bunch of cvars:
- **ud_upsidedown** <0/1> - Default: 1 (**enabled**) - Changes physics so that the ceiling is the new floor for the player
- **ud_pushables** <0/1> - Default: 1 (**enabled**) - Applies the upside down physics to pushable objects as well, like most boxes and barrels, so that you can use them to object boost or simply climb
- **ud_throwables** <0/1> - Default: 1 (**enabled**) - Applies the upside down physics to grenades, satchels and snarks, so that they don't gravitate towards the floor (your ceiling)
- **ud_headcrabs** <0/1> - Default: 1 (**enabled**) - Makes headcrabs gravitate towards the ceiling (your floor) so that you can maybe use them to climb out of a room by jumping on them, and makes them give you a vertical boost when you're jumping so that again you can keep advancing (vent to server room in UC)
- **ud_autojump** <0/1> - Default: 0 (**disabled**) - The official BunnymodXT's autojump is not available as it fails to detect a bunch of things in this mod, so I built it into the mod
- **ud_gauss_multiplayer** <0/1> - Default: 0 (**disabled**) - On singleplayer it allows you to fly upwards and reload the gauss weapon faster like in multiplayer

This mod also changes maps to make them passable, for now:
- **c1a0c** - Test chamber in UC, post-disaster - Changes one of the big pillars so that you slowly slide up (works at 250fps), and a couple of beams so that you can use them to make the jump to the little window in the room where multiple rays hit and break the door open. Still not an easy map to run upside down

## Building in VS Code

### Windows

- Use task `Build both Debug DLLs` to build `cl_dll` and `dlls`
- The helper script `.vscode/invoke-nmake.ps1` auto-detects Visual Studio Build Tools
- Older MSVC is preferred by default through `.vscode/legacy-msvc.bat` (VS2008 -> VS2005 -> VS2003)
- If no legacy toolchain is found, tasks automatically fall back to the modern Visual Studio Build Tools environment
- Edit `.vscode/legacy-msvc.bat` if your legacy compiler is installed in a custom location
- To override this, set environment variable `HL_TOOLCHAIN_BAT` to your compiler setup batch file path before starting VS Code
- If you want VS2003 compilers, headers and whatever `legacy-msvc.bat` uses, I'm using exactly these:
  - Microsoft Platform SDK: https://www.microsoft.com/en-us/download/details.aspx?id=15656
  - Microsoft Visual Studio .NET 2003 Professional: https://archive.org/details/microsoft-visual-studio-.-net-2003-professional-disc-1
  - Microsoft Visual C++ Toolkit 2003: https://archive.org/details/microsoft-visual-c-toolkit-2003

Example (PowerShell):

```powershell
$env:HL_TOOLCHAIN_BAT = 'C:\LegacyVC\Bin\vcvars32.bat'
code .
```

### Debian/Linux

- Use task `Build Debian dlls (hl_i386.so)` for the server game DLL in `dlls/Makefile`
- Use task `Build Debian dedicated (hlds_run)` for the dedicated launcher in `dedicated/Makefile`
- Use task `Build Debian all` to run both
- Note: this repository does not include a Linux Makefile for `cl_dll` (client DLL), only for server-side targets

Half Life 1 SDK LICENSE
======================

Half Life 1 SDK Copyright© Valve Corp.  

THIS DOCUMENT DESCRIBES A CONTRACT BETWEEN YOU AND VALVE CORPORATION (“Valve”).  PLEASE READ IT BEFORE DOWNLOADING OR USING THE HALF LIFE 1 SDK (“SDK”). BY DOWNLOADING AND/OR USING THE SOURCE ENGINE SDK YOU ACCEPT THIS LICENSE. IF YOU DO NOT AGREE TO THE TERMS OF THIS LICENSE PLEASE DON’T DOWNLOAD OR USE THE SDK.

You may, free of charge, download and use the SDK to develop a modified Valve game running on the Half-Life engine.  You may distribute your modified Valve game in source and object code form, but only for free. Terms of use for Valve games are found in the Steam Subscriber Agreement located here: http://store.steampowered.com/subscriber_agreement/ 

You may copy, modify, and distribute the SDK and any modifications you make to the SDK in source and object code form, but only for free.  Any distribution of this SDK must include this license.txt and third_party_licenses.txt.  
 
Any distribution of the SDK or a substantial portion of the SDK must include the above copyright notice and the following: 

DISCLAIMER OF WARRANTIES.  THE SOURCE SDK AND ANY OTHER MATERIAL DOWNLOADED BY LICENSEE IS PROVIDED “AS IS”.  VALVE AND ITS SUPPLIERS DISCLAIM ALL WARRANTIES WITH RESPECT TO THE SDK, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, TITLE AND FITNESS FOR A PARTICULAR PURPOSE.  

LIMITATION OF LIABILITY.  IN NO EVENT SHALL VALVE OR ITS SUPPLIERS BE LIABLE FOR ANY SPECIAL, INCIDENTAL, INDIRECT, OR CONSEQUENTIAL DAMAGES WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION, LOSS OF BUSINESS INFORMATION, OR ANY OTHER PECUNIARY LOSS) ARISING OUT OF THE USE OF OR INABILITY TO USE THE ENGINE AND/OR THE SDK, EVEN IF VALVE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.  
 
 
If you would like to use the SDK for a commercial purpose, please contact Valve at sourceengine@valvesoftware.com.


Half-Life 1
======================

This is the README for the Half-Life 1 engine and its associated games.

Please use this repository to report bugs and feature requests for Half-Life 1 related products.

Reporting Issues
----------------

If you encounter an issue while using Half-Life 1 games, first search the [issue list](https://github.com/ValveSoftware/halflife/issues) to see if it has already been reported. Include closed issues in your search.

If it has not been reported, create a new issue with at least the following information:

- a short, descriptive title;
- a detailed description of the issue, including any output from the command line;
- steps for reproducing the issue;
- your system information.\*; and
- the `version` output from the in‐game console.

Please place logs either in a code block (press `M` in your browser for a GFM cheat sheet) or a [gist](https://gist.github.com).

\* The preferred and easiest way to get this information is from Steam's Hardware Information viewer from the menu (`Help -> System Information`). Once your information appears: right-click within the dialog, choose `Select All`, right-click again, and then choose `Copy`. Paste this information into your report, preferably in a code block.

Conduct
-------


There are basic rules of conduct that should be followed at all times by everyone participating in the discussions.  While this is generally a relaxed environment, please remember the following:

- Do not insult, harass, or demean anyone.
- Do not intentionally multi-post an issue.
- Do not use ALL CAPS when creating an issue report.
- Do not repeatedly update an open issue remarking that the issue persists.

Remember: Just because the issue you reported was reported here does not mean that it is an issue with Half-Life.  As well, should your issue not be resolved immediately, it does not mean that a resolution is not being researched or tested.  Patience is always appreciated.
