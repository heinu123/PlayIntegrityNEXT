#su -c "cd /storage/emulated/0 && /system/bin/curl -L "https://raw.githubusercontent.com/daboynb/PlayIntegrityNEXT/main/Fp_Downloader.apk%20to%20use%20with%20play%20integrity%20by%20chiteroman/fp.sh" -o fp.sh && /system/bin/sh fp.sh"


echo
echo "[+] Deleting old pif.json"
rm -f "/data/adb/pif.json" > /dev/null 
echo

echo "[+] Check if the miui eu inject module is present"
pm disable eu.xiaomi.module.inject > /dev/null 2>&1 && echo -e "The miui eu inject module is disabled now. YOU NEED TO REBOOT OR YOU WON'T BE ABLE TO PASS DEVICE INTEGRITY!." || true
echo

echo "[+] Downloading the pif.json"
/system/bin/curl -L http://tinyurl.com/autojson -o /data/adb/pif.json > /dev/null 2>&1 || /system/bin/curl -L http://tinyurl.com/autojson -o /data/adb/pif.json
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