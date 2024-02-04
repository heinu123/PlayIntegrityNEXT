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

modules_dir="/data/adb/modules"

for subdir in "$modules_dir"/*/; do
    if [ -d "$subdir" ]; then
        module_prop="$subdir/module.prop"
        
        if [ -f "$module_prop" ]; then
            module_name=$("$busybox_type" grep -E 'name=Zygisk Next|name=Play Integrity Fix|name=playcurl' "$module_prop")            
            [ -z "$module_name" ] && touch "$subdir/disable"
        fi
    fi
done