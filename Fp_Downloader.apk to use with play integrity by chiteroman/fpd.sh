# Run the fp command and then disable other modules 
/system/bin/fp
clear

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

# Disable other modules for testing incompatibility
list="$("$busybox_path" find /data/adb/modules/* -prune -type d)"
for module in $list; do
    touch "$module/disable"
done

rm /data/adb/modules/playintegrityfix/disable > /dev/null 2>/dev/null
rm /data/adb/modules/playcurl/disable > /dev/null 2>/dev/null
rm /data/adb/modules/zygisksu/disable > /dev/null 2>/dev/null

# Auto delete the script
rm "$0" > /dev/null 2>/dev/null

reboot >/dev/null 2>&1

echo "The phone should have rebooted by itself. If you are reading this, reboot manually!"