#su -c "cd /storage/emulated/0 && /data/adb/modules/playcurl/curl -L "https://raw.githubusercontent.com/daboynb/PlayIntegrityNEXT/main/Fp_Downloader.apk%20to%20use%20with%20play%20integrity%20by%20chiteroman/fp.sh" -o fp.sh && /system/bin/sh fp.sh"

su 
{
  if [ -f /data/adb/pif.json ]; then
    rm "/data/adb/pif.json"
    echo "File /data/adb/pif.json removed." >> /storage/emulated/0/fp.log
  else
    echo "Continue" >> /storage/emulated/0/fp.log
  fi
}

/data/adb/modules/playcurl/curl -o /data/adb/pif.json https://raw.githubusercontent.com/daboynb/autojson/main/pif.json >> /storage/emulated/0/fp.log

{
  if pgrep -f com.google.android.gms > /dev/null; then
    pkill -f com.google.android.gms
    echo "com.google.android.gms process killed." >> /storage/emulated/0/fp.log
  else
    echo "com.google.android.gms process is not running." >> /storage/emulated/0/fp.log
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

if [ -e /data/adb/pif.json ]; then 
    echo "Pif.json downloaded succesfully"; 
else 
    echo "Pif.json not present, something went wrong."
fi

sleep 03

exit