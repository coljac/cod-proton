#!/bin/bash

# Use this script if your controllers won't work from steam
printhelp() {
    echo "Usage: cod_run_wine.sh [-s /path/to/steam] [-p path/to/proton] [-l /path/to/Launcher64.exe]

With optional flags:
-s, --steam-dir: Path the steam root where the game is installed.
-p, --proton: The proton installation to use to run the game; 'proton' should be in this directory.
-l, --launcher: The full path to the game's Launcher64.exe 

## Examples
cod_run_wine.sh -s /ssd/steam -p \"/ssd/steam/steamapps/common/Proton - Experimental\" -l \"/ssd/steam/steamapps/common/IL-2 Sturmovik Cliffs of Dover Blitz Edition/Launcher64.exe\"
"
}


allargs=$@
for arg in "$@"
do
    case $arg in
        help|--help)
        printhelp
        exit
        shift
        ;;
        -s|--steam-dir)
        STEAM_INSTALL="$2"
        shift
        # shift
        ;;
        -l|--launcher)
        LAUNCHER="$2"
        shift
        # shift
        ;;
        -p|--proton)
        PROTON="$2"
        shift
        ;;
        # OTHER_ARGUMENTS+=("$1")
        # shift # Remove generic argument from processing
        # ;;
    esac
done
# echo "Running script with these args:" $allargs


STEAMID=754530
if [ -z "$STEAM_INSTALL" ] && [ -e "$HOME/.local/share/Steam" ]
then
    STEAM_INSTALL="$HOME/.local/share/Steam"
fi

if [ ! -e "$STEAM_INSTALL" ]
then
    echo "Can't find steam at '$STEAM_INSTALL'. Try again with cod_run_wine.sh -s /path/to/steam"
    exit 1
fi

gamedir="$STEAM_INSTALL/steamapps/common/IL-2 Sturmovik Cliffs of Dover Blitz" 
pfxdir="$STEAM_INSTALL/steamapps/compatdata/$STEAMID/pfx"
proton="$STEAM_INSTALL/steamapps/common/Proton - Experimental"

if [ ! -e "$gamedir" ]
then
    echo "Can't find game at '$gamedir'. Try again with cod_run_wine.sh -s /path/to/steam OR -l /path/to/Launcher64.exe"
    exit 1
fi

if [ -z "$LAUNCHER" ]
then
    LAUNCHER="$gamedir/Launcher64.exe"
fi

if [ ! -e "$LAUNCHER" ]
then
    echo "Launcher64.exe not found. Check paths."
    exit 1
fi


if [ ! -e "$pfxdir" ]
then
    echo "Can't find game prefix at '$pfxdir'. Have you run the game at least once? Specify the steam dir and try again."
    exit 1
fi

if [ ! -e "$proton/proton" ]
then
    echo "Can't find proton at '$proton'. Specify proton location with '-p'."
    exit 1
fi

# Find the library dir
# Only tested on ubuntu
steam_runtime=$STEAM_INSTALL/ubuntu12_32/steam-runtime
if [ ! -e "$steam_runtime" ]
then
    steam_runtime=$(find $STEAM_INSTALL | grep 'steam-runtime$')
fi

libdirs=(pinned_libs_32 pinned_libs_64 usr/lib lib/i386-linux-gnu usr/lib/i386-linux-gnu lib/x86_64-linux-gnu usr/lib/x86_64-linux-gnu lib usr/lib )
for libdir in ${libdirs[@]}
do
    if [ ! -e "$steam_runtime/$libdir" ]
    then
        echo $libdir
    fi
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH":"$steam_runtime/$libdir"
done
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH":"$gamedir"


export WINEPREFIX=$pfxdir
export PROTON_USE_WINED3D=1 
export STEAM_COMPAT_DATA_PATH="$WINEPREFIX"
export STEAM_COMPAT_APP_ID="754530"
export STEAM_COMPAT_INSTALL_PATH="$gamedir"
export STEAM_COMPAT_LIBRARY_PATHS="$STEAM_INSTALL/steamapps:/ssd/steam/steamapps"
export STEAM_COMPAT_MEDIA_PATH="$STEAM_INSTALL/steamapps/shadercache/754530/fozmediav1"
export STEAM_COMPAT_FLAGS="search-cwd"
export STEAM_COMPAT_DATA_PATH="$STEAM_INSTALL/steamapps/compatdata/754530"
export STEAM_COMPAT_SHADER_PATH="$STEAM_INSTALL/steamapps/shadercache/754530"
export STEAM_COMPAT_TOOL_PATHS="$proton:/ssd/steam/steamapps/common/SteamLinuxRuntime_soldier"
export STEAM_COMPAT_MOUNTS=
export STEAM_COMPAT_TRANSCODED_MEDIA_PATH="$STEAM_INSTALL/steamapps/shadercache/754530/swarm"
export STEAM_COMPAT_CLIENT_INSTALL_PATH="$STEAM_INSTALL"

wine_binary="$proton/dist/bin/wine"
if [ ! -e "$wine_binary" ]
then
    wine_binary="$proton/files/bin/wine"
fi

cd "$gamedir"
# Or try proton run Launcher64.exe
"$wine_binary" "$LAUNCHER"
