# Detect busybox
magisk_busybox="/data/adb/magisk/busybox"
ksu_busybox="/data/adb/ksu/bin/busybox"
ap_busybox="/data/adb/ap/bin/busybox"

# Set path
if [ -f "$magisk_busybox" ]; then
    busybox_type="$magisk_busybox"
elif [ -f "$ksu_busybox" ]; then
    busybox_type="$ksu_busybox"
elif [ -f "$ap_busybox" ]; then
    busybox_type="$ap_busybox"
fi

echo Your busybox is "$busybox_type"

# Modules path
modules_dir="/data/adb/modules"

# Disable other modules for testing incompatibility 
disabled_modules=()
for subdir in "$modules_dir"/*/; do
    if [ -d "$subdir" ]; then
        module_prop="$subdir/module.prop"
        
        if [ -f "$module_prop" ]; then
            module_name=$("$busybox_type" grep -E 'name=Zygisk Next|name=Play Integrity Fix|name=playcurl' "$module_prop")            
            if [ -z "$module_name" ]; then
                touch "$subdir/disable"
                disabled_module_name=$(basename "$subdir")
                disabled_modules+=("$disabled_module_name")
            fi
        fi
    fi
done

if [ ${#disabled_modules[@]} -gt 0 ]; then
    echo "Disabled modules: ${disabled_modules[@]}"
else
    echo "No modules disabled."
fi