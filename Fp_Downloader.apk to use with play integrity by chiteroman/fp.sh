#su -c "cd /storage/emulated/0 && /system/bin/curl -L "https://raw.githubusercontent.com/daboynb/PlayIntegrityNEXT/main/Fp_Downloader.apk%20to%20use%20with%20play%20integrity%20by%20chiteroman/fp.sh" -o fp.sh && /system/bin/sh fp.sh"

# Checks
if [ -f "/data/adb/magisk/busybox" ]; then
    if /data/adb/magisk/busybox cat /data/adb/modules/playintegrityfix/module.prop | /data/adb/magisk/busybox grep -q 'NEXT'; then
        echo "Wrong setup! Rtfm!"
        exit
    fi
fi

if [ -f "/data/adb/ksu/bin/busybox" ]; then
    if /data/adb/ksu/bin/busybox cat /data/adb/modules/playintegrityfix/module.prop | /data/adb/magisk/busybox grep -q 'NEXT'; then
        echo "Wrong setup! Rtfm!"
        exit
    fi
fi

if [ -f "/data/adb/ap/bin/busybox" ]; then
    if /data/adb/ap/bin/busybox cat /data/adb/modules/playintegrityfix/module.prop | /data/adb/magisk/busybox grep -q 'NEXT'; then
        echo "Wrong setup! Rtfm!"
        exit
    fi
fi
# End of checks

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

echo "[+] Check if inject apks are present"
pm disable eu.xiaomi.module.inject > /dev/null 2>&1 && echo "The miui eu inject apk is disabled now. YOU NEED TO REBOOT OR YOU WON'T BE ABLE TO PASS DEVICE INTEGRITY!." || true
pm disable com.goolag.pif > /dev/null 2>&1 && echo "The Evolution X inject apk is disabled now. YOU NEED TO REBOOT OR YOU WON'T BE ABLE TO PASS DEVICE INTEGRITY!." || true
pm disable com.lineageos.pif > /dev/null 2>&1 && echo "The Lineage inject apk is disabled now. YOU NEED TO REBOOT OR YOU WON'T BE ABLE TO PASS DEVICE INTEGRITY!." || true
echo

echo "[+] Downloading the pif.json"

if [ -f /data/adb/modules/playintegrityfix/migrate.sh ]; then
    /system/bin/curl -L "https://raw.githubusercontent.com/daboynb/autojson/main/pif.json" -o /data/adb/modules/playintegrityfix/custom.pif.json > /dev/null 2>&1 || /system/bin/curl -L "https://raw.githubusercontent.com/daboynb/autojson/main/pif.json" -o /data/adb/modules/playintegrityfix/custom.pif.json
else
    /system/bin/curl -L "https://raw.githubusercontent.com/daboynb/autojson/main/pif.json" -o /data/adb/pif.json > /dev/null 2>&1 || /system/bin/curl -L "https://raw.githubusercontent.com/daboynb/autojson/main/pif.json" -o /data/adb/pif.json
fi

echo "[+] Killing com.google.android.gms"
pkill -f com.google.android.gms > /dev/null 
echo

echo "[+] Killing com.google.android.gms.unstable"
pkill -f com.google.android.gms.unstable > /dev/null 
echo

if [ -f /data/adb/pif.json ] || [ -f /data/adb/modules/playintegrityfix/custom.pif.json ]; then
    echo "[+] Pif.json downloaded successfully"
else
    echo "[+] Pif.json is not present, something went wrong."
fi

echo
echo "[+] Kernel:"
echo
uname -r
echo

rm "$0"