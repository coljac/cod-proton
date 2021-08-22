# IL-2 Sturmovik Cliffs of Dover Blitz Edition on linux with proton

Here's what I had to do to get the game to run:

1. Try and run the game once, to create the compat data folder (the wine prefix).
2. Create a symlink to the steam userdata folder inside the wineprefix: `ln -s "$HOME/.steam/root/userdata" "$HOME/.local/share/Steam/steamapps/compatdata/754530/pfx/drive_c/Program Files (x86)/Steam/userdata"`
3. Create symlinks for some dlls into the root folder of the game. For each dll in `parts/core`, `ln -s parts/core/{name}.dll {name}.dll`
4. Choose "Proton - Experimental" or the latest proton 6.3-6.
5. Change the run command to `PROTON_USE_WINED3D=1 %command%`

You can run the script `cod_fix.sh` to do this for you; if your steam library and game aren't in the default (on my system) locations, enter the location when prompted or edit the script.

## Using USB pedals

I had an issue getting the game to detect my CH Pro Pedals USB device, even though the OS can see them just fine and they do work in some other games. After much experimentation I found that running the game with wine or proton outside of steam resulted in the game working. If this is a problem for you, try wine with:

`WINEPREFIX="$HOME/.local/share/Steam/steamapps/compatdata/754530/pfx" "/path/to/proton/files/bin/wine" "/path/to/IL-2 Sturmovik Cliffs of Dover Blitz/Launcher64.exe"`

or, try the script `cod_run_wine.sh` here. When I run this way the pedals are detected and work well. (I've only tested on ubuntu 20.04 so the script and environment variables might need tweaking for other OSes).

## Head tracking

I got head tracking to work with [opentrack](https://github.com/opentrack/opentrack). The instructions I followed are [these](https://skrapeprojects.github.io/opentrack-wine-guide/). I had to do the following:

1. Uninstall wine, install packages `winehq-devel` and `wine-devel-dev` from [winehq](https://wiki.winehq.org/Download).
2. Build opentrack with SDK_WINE set to ON.
3. Configure opentrack with the right proton version and game id (754530).
4. Start and stop opentrack, start the game, then start opentrack again.

## Other Issues

When not using a tiling window manager, I found the game would start in full screen mode with an annoying offset - i.e. a black area in the top and left of the game, and the mouse detection was offset too. This goes away after launching into the game proper, though.

I also noticed (again on a non-tiling window manager) that when starting the game proper the game would minimise and you have to alt-tab back in.

Please open an issue if you have other problems, OR if proton evolves and the game starts perfectly without hacks.

Make a report on protondb.com if you have a good experience.
