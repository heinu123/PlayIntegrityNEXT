#su -c "cd /storage/emulated/0 && /data/adb/modules/playcurl/curl -L "https://raw.githubusercontent.com/daboynb/PlayIntegrityNEXT/main/Gms%20apk%20to%20use%20with%20play%20integrity%20next/gms.sh" -o gms.sh && /system/bin/sh gms.sh"

su 
{
  if [ -f /data/adb/pif.json ]; then
    rm "/data/adb/pif.json"
    echo "File /data/adb/pif.json removed."
  else
    echo "Continue"
  fi
}

{
  if pgrep -f com.google.android.gms > /dev/null; then
    pkill -f com.google.android.gms
    echo "com.google.android.gms process killed."
  else
    echo "com.google.android.gms process is not running."
  fi
}

{
  if pgrep -f com.google.android.gms.unstable > /dev/null; then
    pkill -f com.google.android.gms.unstable
    echo "com.google.android.gms.unstable process killed."
  else
    echo "com.google.android.gms.unstable process is not running, no need to kill."
  fi
}