#su -c "cd /storage/emulated/0 && /system/bin/curl -L "https://raw.githubusercontent.com/daboynb/PlayIntegrityNEXT/main/Fp_Downloader.apk%20to%20use%20with%20play%20integrity%20by%20chiteroman/fp.sh" -o fp.sh && /system/bin/sh fp.sh"

# Detect busybox
busybox_paths=(
    "/data/adb/magisk/busybox"
    "/data/adb/ksu/bin/busybox"
    "/data/adb/ap/bin/busybox"
)

busybox_path=""

for path in "${busybox_paths[@]}"; do
    if [ -f "$path" ]; then
        busybox_path="$path"
        break
    fi
done

# Check if the setup is correct
if "$busybox_path" grep -q 'NEXT' /data/adb/modules/playintegrityfix/module.prop; then
    echo
    echo "Wrong setup! Remove play integrity fix next and download the official chiteroman module! Playcurl is meant to be used alongside pif official!"
    exit
fi

# Check if the user is root
current_user=$("$busybox_path" whoami)

if [ "$current_user" != "root" ]; then
    echo "You are not the root user. This script requires root privileges."
    exit 1
fi

# Delete outdated pif.json
file_paths=(
    "/data/adb/pif.json"
    "/data/adb/modules/playintegrityfix/pif.json"
    "/data/adb/modules/playintegrityfix/custom.pif.json"
)

file_path=""

for file_path in "${file_paths[@]}"; do
    echo "[+] Deleting ${file_path}"
    if [ -f "$file_path" ]; then
        rm -f "$file_path" > /dev/null
    fi
done
echo

# Disable problematic packages
echo "[+] Check if inject apks are present"
apk_names=("eu.xiaomi.module.inject" "com.goolag.pif" "com.lineageos.pif")
pif_apk=false

for apk in "${apk_names[@]}"; do
    if pm disable "$apk" 2>/dev/null; then
        echo
        echo "[+] The ${apk} apk is now disabled. YOU NEED TO REBOOT OR YOU WON'T BE ABLE TO PASS DEVICE INTEGRITY!"
        pif_apk=true
    fi
done
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
package_names=("com.google.android.gms" "com.google.android.gms.unstable")

for package in "${package_names[@]}"; do
    echo "[+] Killing ${package}"
    pkill -f "${package}" > /dev/null
    echo
done

# Check if the pif is present
if [ -f /data/adb/pif.json ] || [ -f /data/adb/modules/playintegrityfix/custom.pif.json ]; then
    echo "[+] Pif.json downloaded successfully"
else
    echo "[+] Pif.json is not present, something went wrong."
fi

# Check if the kernel name is banned, banned kernels names from https://xdaforums.com/t/module-play-integrity-fix-safetynet-fix.4607985/post-89308909 and telegram
get_kernel_name=$(uname -r)
banned_names=("aicp" "arter97" "blu_spark" "cm" "crdroid" "cyanogenmod" "deathly" "eas" "elementalx" "elite" "franco" "lineage" "lineageos" "noble" "optimus" "slimroms" "sultan" "evox")
is_banned=false

for keyword in "${banned_names[@]}"; do
    if echo "$get_kernel_name" | "$busybox_path" grep -iq "$keyword"; then
        echo
        echo "[-] Your kernel name \"$keyword\" is banned. If you are passing device integrity you can ignore this mesage, otherwise that's probably the cause. "
        is_banned=true
    fi
done

# Auto delete the script
rm "$0"