set_perm $MODPATH/system/bin/fp root root 0777
set_perm $MODPATH/system/bin/fpd root root 0777
set_perm $MODPATH/system/bin/fpa root root 0777
mv -f $MODPATH/system/bin/$ABI/curl $MODPATH/system/bin
set_perm $MODPATH/system/bin/curl root root 777

# Code by https://xdaforums.com/t/guide-volume-key-selection-in-flashable-zip.3773410/
# Get option from zip name if applicable
case $(basename $ZIP) in
  *new*|*New*|*NEW*) NEW=true;;
  *old*|*Old*|*OLD*) NEW=false;;
esac

# Change this path to wherever the keycheck binary is located in your installer
KEYCHECK=$MODPATH/keycheck
chmod 755 $KEYCHECK

keytest() {
  ui_print "- Vol Key Test -"
  ui_print "   Press a Vol Key:"
  (/system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > $INSTALLER/events) || return 1
  return 0
}   

choose() {
  #note from chainfire @xda-developers: getevent behaves weird when piped, and busybox grep likes that even less than toolbox/toybox grep
  while true; do
    /system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > $INSTALLER/events
    if (`cat $INSTALLER/events 2>/dev/null | /system/bin/grep VOLUME >/dev/null`); then
      break
    fi
  done
  if (`cat $INSTALLER/events 2>/dev/null | /system/bin/grep VOLUMEUP >/dev/null`); then
    return 0
  else
    return 1
  fi
}

chooseold() {
  # Calling it first time detects previous input. Calling it second time will do what we want
  $KEYCHECK
  $KEYCHECK
  SEL=$?
  if [ "$1" == "UP" ]; then
    UP=$SEL
  elif [ "$1" == "DOWN" ]; then
    DOWN=$SEL
  elif [ $SEL -eq $UP ]; then
    return 0
  elif [ $SEL -eq $DOWN ]; then
    return 1
  else
    ui_print "   Vol key not detected!"
    abort "   Use name change method in TWRP"
  fi
}
ui_print " "
if [ -z $NEW ]; then
  if keytest; then
    FUNCTION=choose
  else
    FUNCTION=chooseold
    ui_print "   ! Legacy device detected! Using old keycheck method"
    ui_print " "
    ui_print "- Vol Key Programming -"
    ui_print "   Press Vol Up Again:"
    $FUNCTION "UP"
    ui_print "   Press Vol Down"
    $FUNCTION "DOWN"
  fi
  ui_print " "
  ui_print "- Select Option -"
  ui_print "   Choose which option you want installed:"
  ui_print "   Vol Up = The fp command will run automatically every 6 hours."
  ui_print "   Vol Down = When the fp is banned, you will need to manually open the fp app or run the 'fp' command in Termux."

  if $FUNCTION; then 
    NEW=true
  else 
    NEW=false
  fi
else
  ui_print "   Option specified in zipname!"
fi

if $NEW; then
  rm -rf $MODPATH/system/app/com.fp.downloader
else
  rm -rf $MODPATH/system/app/com.fp.downloader.auto
fi