#su -c "cd /storage/emulated/0 && /system/bin/curl -L "https://raw.githubusercontent.com/daboynb/PlayIntegrityNEXT/main/Gms%20apk%20to%20use%20with%20play%20integrity%20next/gms.sh" -o gms.sh && /system/bin/sh gms.sh"

## ANSI Colors thanks to termux-style
RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"  CYAN="$(printf '\033[36m')"  WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')"  GREENBG="$(printf '\033[42m')"  ORANGEBG="$(printf '\033[43m')"  BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"  WHITEBG="$(printf '\033[47m')" BLACKBG="$(printf '\033[40m')"
DEFAULT_FG="$(printf '\033[39m')"  DEFAULT_BG="$(printf '\033[49m')"

## Banner
banner () {
    clear
    echo -e "
    ${GREEN}#########################################################
    ${GREEN}# PIF NEXT https://github.com/daboynb/PlayIntegrityNEXT #
    ${GREEN}#########################################################"

}
banner

echo
echo -e "${GREEN}[+] Deleting old pif.json"
rm -f "/data/adb/pif.json" > /dev/null 
echo

echo -e "${GREEN}[+] Killing com.google.android.gms"
pkill -f com.google.android.gms > /dev/null 
echo

echo -e "${GREEN}[+] Killing com.google.android.gms.unstable"
pkill -f com.google.android.gms.unstable > /dev/null 
echo

rm "$0"