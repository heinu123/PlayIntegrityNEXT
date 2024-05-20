# Set permissions
set_perm $MODPATH/system/bin/fp root root 0777
set_perm $MODPATH/system/bin/fpd root root 0777
set_perm $MODPATH/system/bin/fpa root root 0777
set_perm $MODPATH/system/bin/fpt root root 0777
mv -f $MODPATH/system/bin/$ABI/curl $MODPATH/system/bin
set_perm $MODPATH/system/bin/curl root root 777