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

if pm list packages | "$busybox_path" grep "com.autopif.x1337cn" > /dev/null; then
    pm uninstall "com.autopif.x1337cn" > /dev/null 2>&1
fi

if "$busybox_path" grep -q 'x1337cn' /data/adb/modules/playcurl/module.prop; then
    echo
    rm -rf /data/adb/modules/playcurl
    echo "Wrong setup! Download playcurl from https://github.com/daboynb/PlayIntegrityNEXT/releases/tag/playcurl"
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

# Disable problematic packages, miui eu, EvoX, lineage, PixelOS, autopif
apk_names=("eu.xiaomi.module.inject" "com.goolag.pif" "com.lineageos.pif" "co.aospa.android.certifiedprops.overlay")
echo "[+] Check if inject apks are present"

for apk in "${apk_names[@]}"; do
    pm uninstall "$apk" > /dev/null 2>&1
    if ! pm list packages -d | "$busybox_path" grep "$apk" > /dev/null; then
        if pm disable "$apk" > /dev/null 2>&1; then
            echo "[+] The ${apk} apk is now disabled. YOU NEED TO REBOOT OR YOU WON'T BE ABLE TO PASS DEVICE INTEGRITY!"
        fi
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

spic="com.henrikherzig.playintegritychecker"
local_apk_path="/data/local/tmp/spic-v1.4.0.apk"
apk_url="https://github.com/herzhenr/spic-android/releases/download/v1.4.0/spic-v1.4.0.apk"

# Check if SPIC app is already installed
if pm list packages | "$busybox_path" grep "$spic" >/dev/null 2>&1; then
    echo ""
    echo "The SPIC app is already installed!"
    echo ""
else
    echo "Downloading SPIC app..."
    /system/bin/curl -L "$apk_url" -o "$local_apk_path" >/dev/null 2>&1

    echo "Installing SPIC app..."
    pm install "$local_apk_path"
    rm "$local_apk_path" >/dev/null 2>&1
fi

killall $spic >/dev/null 2>&1

echo "The SPIC app will open in 3 seconds... DO NOT TOUCH ANYTHING!"
echo ""
sleep 3

am start -n $spic/$spic.MainActivity >/dev/null 2>&1
sleep 3

input keyevent KEYCODE_DPAD_UP
sleep 1
input keyevent KEYCODE_DPAD_UP
sleep 1
input keyevent KEYCODE_DPAD_UP
sleep 1
input keyevent KEYCODE_ENTER
sleep 10

STORAGE_DIR="/storage/emulated/0"
xml="${STORAGE_DIR}/testresult.xml"

uiautomator dump "$xml" >/dev/null 2>&1

killall $spic >/dev/null 2>&1

spic_error="TOO_MANY_REQUESTS" 
if grep -q "$spic_error" "$xml"; then
    echo ""
    echo "$spic_error detected."
    echo ""
    echo "The app hit the maximum API request per day!"
fi
exit

integrities=("NO_INTEGRITY" "MEETS_BASIC_INTEGRITY" "MEETS_DEVICE_INTEGRITY" "MEETS_STRONG_INTEGRITY")
resultlog="${STORAGE_DIR}/piftest_results.log"

for meets in $integrities; do
    if "$busybox_path" grep -q "$meets" "$xml"; then
        echo "$meets detected." | tee -a "$resultlog"
        break
    fi
done

if [ "$meets" = "NO_INTEGRITY" ] || [ "$meets" = "MEETS_BASIC_INTEGRITY" ]; then
    echo "Running the fpd command, the phone will reboot!"
    rm $xml >/dev/null 2>&1
    rm $resultlog >/dev/null 2>&1
    fpd
fi