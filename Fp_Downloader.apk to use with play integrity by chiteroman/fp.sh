#su -c "cd /storage/emulated/0 && /system/bin/curl -L \"https://raw.githubusercontent.com/daboynb/PlayIntegrityNEXT/main/Fp_Downloader.apk%20to%20use%20with%20play%20integrity%20by%20chiteroman/fp.sh\" -o fp.sh && /system/bin/sh fp.sh"

clear
echo
echo -e "\033[1;32m[+] Deleting old pif.json\033[0m"
rm -f "/data/adb/pif.json" > /dev/null
echo

echo -e "\033[1;32m[+] Check if the miui eu inject module is present\033[0m"
pm disable eu.xiaomi.module.inject > /dev/null 2>&1 && echo -e "\033[1;32mThe miui eu inject module is disabled. Please reboot to ensure that the modification takes effect.\033[0m" || true
echo

echo -e "\033[1;32m[+] Downloading the pif.json\033[0m"
/system/bin/curl -o /data/adb/pif.json http://tinyurl.com/autojson > /dev/null 2>&1 || /system/bin/curl -o /data/adb/pif.json http://tinyurl.com/autojson
echo

echo -e "\033[1;32m[+] Killing com.google.android.gms\033[0m"
pkill -f com.google.android.gms > /dev/null
echo

echo -e "\033[1;32m[+] Killing com.google.android.gms.unstable\033[0m"
pkill -f com.google.android.gms.unstable > /dev/null
echo

if [ -e /data/adb/pif.json ]; then
    echo -e "\033[1;32m[+] Pif.json downloaded successfully\033[0m"
else
    echo -e "\033[1;32m[+] Pif.json not present, something went wrong.\033[0m"
fi

rm "$0"