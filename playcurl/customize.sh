# Set permissions
set_perm $MODPATH/system/bin/fp root root 0777
set_perm $MODPATH/system/bin/fpd root root 0777
set_perm $MODPATH/system/bin/fpa root root 0777
mv -f $MODPATH/system/bin/$ABI/curl $MODPATH/system/bin
set_perm $MODPATH/system/bin/curl root root 777

# Check if wearable since vol keys are not present
wearos="com.google.android.apps.wearable.settings"

if pm list packages | grep "$wearos" >/dev/null 2>&1; then
    echo ""
    echo "Wearos detected!" Installing default profile!
    rm -rf $MODPATH/system/app/com.fp.downloader.auto
    exit 0
fi

######################################################################################
# Check for the Volume key event
key_event_volume_up() {
    /system/bin/getevent -lqc 1 | grep -q "KEY_VOLUMEUP"
}

# Check for the Volume key event
key_event_volume_down() {
    /system/bin/getevent -lqc 1 | grep -q "KEY_VOLUMEDOWN"
}

echo ""
echo "What do I need to select?"
echo ""
echo "This module puts the fp* binaries in /system/bin."
echo "To avoid having to use Termux every time we want to run "
echo "the command, I decided to create a Tasker app too."
echo ""

fp_mode (){
  echo ""
  echo "- Select an option: "
  echo ""
  echo "- Vol Up = Do not install any app. Use termux."
  echo ""
  echo "- Vol Down = Install the fp downloader app."
  echo ""
}

app_choice (){
  echo ""
  echo "- Select an option:"
  echo ""
  echo "- Vol Up = FP auto, the  app will run the fp "
  echo " command automatically every 6 hours."
  echo ""
  echo "- Vol Down = FP manual, when the fp is banned, you will "
  echo " need to manually open the fp app "
  echo " or run the 'fp' command in Termux."
  echo ""
}


# First menu
fp_mode

while true; do

    # Check if Volume Up pressed
    if key_event_volume_up; then
        rm -rf $MODPATH/system/app
        echo "You have chosen no app"
        exit 0
    fi

    # Check if Volume Down pressed
    if key_event_volume_down; then
        break  
    fi

done

# Second menu
app_choice

while true; do

    # Check if Volume Up pressed
    if key_event_volume_up; then
        rm -rf $MODPATH/system/app/com.fp.downloader
        echo "You have chosen Fp auto app"
        exit 0
    fi

    # Check if Volume Down pressed
    if key_event_volume_down; then
        rm -rf $MODPATH/system/app/com.fp.downloader.auto
        echo "You have chosen Fp manual app"
        exit 0
    fi

done
##########################################################################################