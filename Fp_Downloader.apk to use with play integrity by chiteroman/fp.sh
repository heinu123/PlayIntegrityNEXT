#su -c "cd /storage/emulated/0 && /system/bin/curl -L "https://raw.githubusercontent.com/daboynb/PlayIntegrityNEXT/main/Fp_Downloader.apk%20to%20use%20with%20play%20integrity%20by%20chiteroman/fp.sh" -o fp.sh && /system/bin/sh fp.sh"

# Check is the setup is correct
magisk_busybox="/data/adb/magisk/busybox"
ksu_busybox="/data/adb/ksu/bin/busybox"
ap_busybox="/data/adb/ap/bin/busybox"

if [ -f "$magisk_busybox" ]; then
    busybox_type="$magisk_busybox"
elif [ -f "$ksu_busybox" ]; then
    busybox_type="$ksu_busybox"
elif [ -f "$ap_busybox" ]; then
    busybox_type="$ap_busybox"
fi

if "$busybox_type" grep -q 'NEXT' /data/adb/modules/playintegrityfix/module.prop; then
    echo "Wrong setup! Remove play integrity fix next and download the official chiteroman module! Playcurl is meant to be used alongside pif official!"
    exit
fi

# End of checks

# Delete outdated pif.json
echo
echo "[+] Deleting old pif.json"

if [ -f /data/adb/pif.json ]
then
    rm -f "/data/adb/pif.json" > /dev/null 
fi

if [ -f /data/adb/modules/playintegrityfix/pif.json ]
then
    rm -f "/data/adb/modules/playintegrityfix/pif.json" > /dev/null 
fi

if [ -f /data/adb/modules/playintegrityfix/custom.pif.json ]
then
    rm -f "/data/adb/modules/playintegrityfix/custom.pif.json" > /dev/null 
fi
echo

# Disable problematic packages
echo "[+] Check if inject apks are present"
pm disable eu.xiaomi.module.inject > /dev/null 2>&1 && echo "The miui eu inject apk is disabled now. YOU NEED TO REBOOT OR YOU WON'T BE ABLE TO PASS DEVICE INTEGRITY!." || true
pm disable com.goolag.pif > /dev/null 2>&1 && echo "The Evolution X inject apk is disabled now. YOU NEED TO REBOOT OR YOU WON'T BE ABLE TO PASS DEVICE INTEGRITY!." || true
pm disable com.lineageos.pif > /dev/null 2>&1 && echo "The Lineage inject apk is disabled now. YOU NEED TO REBOOT OR YOU WON'T BE ABLE TO PASS DEVICE INTEGRITY!." || true
echo

# Download pif.json
echo "[+] Downloading the pif.json"
if [ -f /data/adb/modules/playintegrityfix/migrate.sh ]; then
    /system/bin/curl -L "https://raw.githubusercontent.com/daboynb/autojson/main/pif.json" -o /data/adb/modules/playintegrityfix/custom.pif.json > /dev/null 2>&1 || /system/bin/curl -L "https://raw.githubusercontent.com/daboynb/autojson/main/pif.json" -o /data/adb/modules/playintegrityfix/custom.pif.json
else
    /system/bin/curl -L "https://raw.githubusercontent.com/daboynb/autojson/main/pif.json" -o /data/adb/pif.json > /dev/null 2>&1 || /system/bin/curl -L "https://raw.githubusercontent.com/daboynb/autojson/main/pif.json" -o /data/adb/pif.json
fi
echo 

# Kill gms processes
echo "[+] Killing com.google.android.gms"
pkill -f com.google.android.gms > /dev/null 
echo

# Kill gms processes
echo "[+] Killing com.google.android.gms.unstable"
pkill -f com.google.android.gms.unstable > /dev/null 
echo

# Check if the pif is present
if [ -f /data/adb/pif.json ] || [ -f /data/adb/modules/playintegrityfix/custom.pif.json ]; then
    echo "[+] Pif.json downloaded successfully"
else
    echo "[+] Pif.json is not present, something went wrong."
fi

# Check if the kernel name is banned
kernel_name=$(uname -r)

# Banned kernels names from https://xdaforums.com/t/module-play-integrity-fix-safetynet-fix.4607985/post-89308909
banned_names=("aicp" "arter97" "blu_spark" "cm" "crdroid" "cyanogenmod" "deathly" "eas" "elementalx" "elite" "franco" "lineage" "lineageos" "noble" "optimus" "slimroms" "sultan")

banned=false

for keyword in "${banned_names[@]}"; do
    if echo "$kernel_name" | "$busybox_type" grep -iq "$keyword"; then
        echo
        echo "[+] Your kernel name \"$keyword\" is banned"
        banned=true
    fi
done

if [ "$banned" = false ]; then
    echo
    echo "[+] Your kernel name is not banned"
fi

rm "$0"