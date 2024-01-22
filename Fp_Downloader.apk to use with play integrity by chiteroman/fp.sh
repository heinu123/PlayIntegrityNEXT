#su -c "cd /storage/emulated/0 && /system/bin/curl -L "https://raw.githubusercontent.com/daboynb/PlayIntegrityNEXT/main/Fp_Downloader.apk%20to%20use%20with%20play%20integrity%20by%20chiteroman/fp.sh" -o fp.sh && /system/bin/sh fp.sh"

rm -f "/data/adb/pif.json" > /dev/null 

/system/bin/curl -o /data/adb/pif.json https://raw.githubusercontent.com/daboynb/autojson/main/pif.json

pkill -f com.google.android.gms > /dev/null 

pkill -f com.google.android.gms.unstable > /dev/null 

if [ -e /data/adb/pif.json ]; then 
    echo "Pif.json downloaded succesfully"
else 
    echo "Pif.json not present, something went wrong."
fi