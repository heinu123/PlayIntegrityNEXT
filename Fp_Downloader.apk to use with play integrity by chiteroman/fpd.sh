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

# Modules path
modules_dir="/data/adb/modules"

# Disable other modules for testing incompatibility 
disabled_modules=()
for subdir in "$modules_dir"/*/; do
    if [ -d "$subdir" ]; then
        module_prop="$subdir/module.prop"
        
        if [ -f "$module_prop" ]; then
            module_name=$("$busybox_path" grep -E 'name=Zygisk Next|name=Play Integrity Fix|name=playcurl' "$module_prop")            
            if [ -z "$module_name" ]; then
                touch "$subdir/disable"
                disabled_module_name=$(basename "$subdir")
                disabled_modules+=("$disabled_module_name")
            fi
        fi
    fi
done

if [ ${#disabled_modules[@]} -gt 0 ]; then
    echo "[+] Disabled modules: ${disabled_modules[@]}"
    reboot
else
    echo "[+] No modules disabled."
fi