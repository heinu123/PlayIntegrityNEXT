#su -c "cd /storage/emulated/0 && /data/adb/modules/playcurl/curl -L "https://raw.githubusercontent.com/daboynb/PlayIntegrityNEXT/main/Gms%20apk%20to%20use%20with%20play%20integrity%20next/gms.sh" -o gms.sh && /system/bin/sh gms.sh"

rm -f "/data/adb/pif.json" > /dev/null 

pkill -f com.google.android.gms > /dev/null 

pkill -f com.google.android.gms.unstable > /dev/null 