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

# Check for zygisk
if [ "$busybox_path" = "/data/adb/ap/bin/busybox" ]; then
  if [ -d "/data/adb/modules/zygisksu" ]; then
    :
  else
    echo You need zygisk!
    rm "$0"
    exit 1
  fi
fi

if [ "$busybox_path" = "/data/adb/ksu/bin/busybox" ]; then
  if [ -d "/data/adb/modules/zygisksu" ]; then
    :
  else
    echo You need zygisk!
    rm "$0"
    exit 1
  fi
fi

# Remove from denylist google play services, google service framework
magisk_package_names=("com.google.android.gms" "com.google.android.gsf" )

if [ "$busybox_path" = "/data/adb/magisk/busybox" ]; then
    for magisk_package in "${magisk_package_names[@]}"; do
        magisk --denylist rm "${magisk_package}" > /dev/null 2>/dev/null
    done
fi
echo "" 

# Delete outdated pif.json
echo "[+] Deleting old pif.json"
file_paths=(
    "/data/adb/pif.json"
    "/data/adb/modules/playintegrityfix/pif.json"
    "/data/adb/modules/playintegrityfix/custom.pif.json"
)

for file_path in "${file_paths[@]}"; do
    if [ -f "$file_path" ]; then
        rm -f "$file_path" > /dev/null
    fi
done
echo

# Disable problematic packages, miui eu, EvoX, lineage, PixelOS
apk_names=("eu.xiaomi.module.inject" "com.goolag.pif" "com.lineageos.pif" "co.aospa.android.certifiedprops.overlay")
echo "[+] Check if inject apks are present"

for apk in "${apk_names[@]}"; do
    if ! pm list packages -d | grep "$apk" > /dev/null; then
        if pm disable "$apk" > /dev/null 2>&1; then
            echo "[+] The ${apk} apk is now disabled. YOU NEED TO REBOOT OR YOU WON'T BE ABLE TO PASS DEVICE INTEGRITY!"
        fi
    fi
done

# Download pif.json
echo "[+] Downloading the pif.json"
if [ -f /data/adb/modules/playintegrityfix/migrate.sh ]; then
    /system/bin/curl -L "https://raw.githubusercontent.com/daboynb/autojson/main/pif.json" -o /data/adb/modules/playintegrityfix/custom.pif.json > /dev/null 2>&1 || /system/bin/curl -L "https://raw.githubusercontent.com/daboynb/autojson/main/pif.json" -o /data/adb/modules/playintegrityfix/custom.pif.json
else
    /system/bin/curl -L "https://raw.githubusercontent.com/daboynb/autojson/main/pif.json" -o /data/adb/pif.json > /dev/null 2>&1 || /system/bin/curl -L "https://raw.githubusercontent.com/daboynb/autojson/main/pif.json" -o /data/adb/pif.json
fi
echo 

# Kill gms processes and wallet
package_names=("com.google.android.gms" "com.google.android.gms.unstable" "com.google.android.apps.walletnfcrel")

echo "[+] Killing some apps"

for package in "${package_names[@]}"; do
    pkill -f "${package}" > /dev/null
done
echo

# Clear the cache of all apps
echo "[+] Clearing cache"
pm trim-caches 999G 
echo

# Check if the pif is present
if [ -f /data/adb/pif.json ] || [ -f /data/adb/modules/playintegrityfix/custom.pif.json ]; then
    echo "[+] Pif.json downloaded successfully"
else
    echo "[+] Pif.json is not present, something went wrong."
fi

# Check if the kernel name is banned, banned kernels names from https://xdaforums.com/t/module-play-integrity-fix-safetynet-fix.4607985/post-89308909 and telegram
get_kernel_name=$(uname -r)
banned_names=("aicp" "arter97" "blu_spark" "cm" "crdroid" "cyanogenmod" "deathly" "eas" "elementalx" "elite" "franco" "lineage" "lineageos" "noble" "optimus" "slimroms" "sultan")

for keyword in "${banned_names[@]}"; do
    if echo "$get_kernel_name" | "$busybox_path" grep -iq "$keyword"; then
        echo
        echo "[-] Your kernel name \"$keyword\" is banned. If you are passing device integrity you can ignore this mesage, otherwise that's probably the cause. "
    fi
done

# Disable other modules for testing incompatibility
list="$("$busybox_path" find /data/adb/modules/* -prune -type d)"
for module in $list; do
    touch "$module/disable"
done

rm /data/adb/modules/playintegrityfix/disable > /dev/null 2>/dev/null
rm /data/adb/modules/playcurl/disable > /dev/null 2>/dev/null
rm /data/adb/modules/zygisksu/disable > /dev/null 2>/dev/null

# Auto delete the script
rm "$0"

reboot