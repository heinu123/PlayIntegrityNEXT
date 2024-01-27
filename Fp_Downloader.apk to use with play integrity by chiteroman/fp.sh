#su -c "cd /storage/emulated/0 && /system/bin/curl -L "https://raw.githubusercontent.com/daboynb/PlayIntegrityNEXT/main/Fp_Downloader.apk%20to%20use%20with%20play%20integrity%20by%20chiteroman/fp.sh" -o fp.sh && /system/bin/sh fp.sh"

echo
echo "[+] Deleting old pif.json"
if [ -f /data/adb/pif.json ]
then
    rm -f "/data/adb/pif.json" > /dev/null 
fi

if [ -f /data/adb/modules/playintegrityfix/custom.pif.json ]
then
    rm -f "/data/adb/modules/playintegrityfix/custom.pif.json" > /dev/null 
fi
echo

echo "[+] Check if the miui eu inject module is present"
pm disable eu.xiaomi.module.inject > /dev/null 2>&1 && echo "The miui eu inject module is disabled now. YOU NEED TO REBOOT OR YOU WON'T BE ABLE TO PASS DEVICE INTEGRITY!." || true
pm disable com.goolag.pif > /dev/null 2>&1 && echo "The Evolution X inject module is disabled now. YOU NEED TO REBOOT OR YOU WON'T BE ABLE TO PASS DEVICE INTEGRITY!." || true
echo

echo "[+] Downloading the pif.json"
if [ -f /data/adb/modules/playintegrityfix/migrate.sh ]  
then
    /system/bin/curl -L "https://raw.githubusercontent.com/daboynb/autojson/main/pif.json" -o /data/adb/modules/playintegrityfix/custom.pif.json > /dev/null 2>&1 || /system/bin/curl -L "https://raw.githubusercontent.com/daboynb/autojson/main/pif.json" -o /data/adb/modules/playintegrityfix/custom.pif.json

else
    /system/bin/curl -L "https://raw.githubusercontent.com/daboynb/autojson/main/pif.json" -o /data/adb/pif.json > /dev/null 2>&1 || /system/bin/curl -L "https://raw.githubusercontent.com/daboynb/autojson/main/pif.json" -o /data/adb/pif.json
fi
echo

echo "[+] Killing com.google.android.gms"
pkill -f com.google.android.gms > /dev/null 
echo

echo "[+] Killing com.google.android.gms.unstable"
pkill -f com.google.android.gms.unstable > /dev/null 
echo

if [ -e /data/adb/pif.json ]; then 
    echo "[+] Pif.json downloaded succesfully"
else 
    echo "[+] Pif.json not present, something went wrong."
fi

rm "$0"