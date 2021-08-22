#!/bin/bash
# export AMD_VK_PIPELINE_CACHE_PATH='/home/coljac/.local/share/Steam/steamapps/shadercache/754530/AMDv1'

STEAMID=754530

gamedir="$HOME/.local/share/Steam/steamapps/common/IL-2 Sturmovik Cliffs of Dover Blitz" 
pfxdir="$HOME/.local/share/Steam/steamapps/compatdata/$STEAMID/pfx"
userdata="$HOME/.steam/root/userdata"

if [ ! -e "$gamedir" ]
then
    found=0
    while [ $found == "0" ]
    do
        echo Location of steam library where game is installed?
        echo -n "Location to steam library: ";
        read;
        maybe="${REPLY}/steamapps/common/IL-2 Sturmovik Cliffs of Dover Blitz"
        echo Looking for $maybe
        if [ -e "$maybe" ]
        then
            gamedir="$maybe"
            pfxdir="${REPLY}/steamapps/common/compatdata/$STEAMID/pfx"
            echo "OK"
            found=1
        fi
    done
fi

if [ ! -e "$pfxdir" ]
then
    echo "No wine prefix found. Run once first with proton."
    exit 0
fi

if [ ! -e "$userdata" ]
then
    found=0
    while [ $found == "0" ]
    do
        echo "Userdata folder not found - where is the steam userdata folder? (Default is $userdata)"
        echo -n "Userdata folder: ";
        read;
        maybe="${REPLY}"
        echo Looking for "$maybe"
        if [ -e "$maybe" ] && [ 1 == `echo $maybe | grep userdata | wc -l` ]
        then
            userdata=$maybe
            echo "OK"
            found=1
        fi
    done
fi

# echo $userdata
cd "$pfxdir/drive_c/Program Files (x86)/Steam"
if [ ! -e "userdata" ]
then
    echo Making symlink for user data folder.
    ln -s "$userdata" userdata
else
    echo Userdata folder exists.
fi

cd "$gamedir"
echo Making symlinks for dlls.
for f in $(ls parts/core/*dll)
do
    if  [ ! -e $(basename $f) ]
    then
        ln -s $f $(basename $f) 
    fi
done

echo
echo "OK. Change the launch options for the game to 'PROTON_USE_WINED3D=1 %command%'."
echo "For joystick support you may need to disable steam input under controller settings for the game."
echo "If you have other control options, look at the cod-launcher.sh script which may help."
