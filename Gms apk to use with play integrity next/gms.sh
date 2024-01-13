su -c '{
  if [ -f /data/adb/pif.json ]; then
    rm "/data/adb/pif.json"
    echo "File /data/adb/pif.json removed."
  else
    echo "Continue" > /storage/emulated/0/gms_termux.log
  fi
}'

su -c '{
  if pgrep -f com.google.android.gms > /dev/null; then
    pkill -f com.google.android.gms
    echo "com.google.android.gms process killed." >> /storage/emulated/0/gms_termux.log
  else
    echo "com.google.android.gms process is not running." >> /storage/emulated/0/gms_termux.log
  fi
}'

su -c '{
  if pgrep -f com.google.android.gms.unstable > /dev/null; then
    pkill -f com.google.android.gms.unstable
    echo "com.google.android.gms.unstable process killed." >> /storage/emulated/0/gms_termux.log
  else
    echo "com.google.android.gms.unstable process is not running, no need to kill." >> /storage/emulated/0/gms_termux.log
  fi
}'

cat /storage/emulated/0/gms_termux.log

rm /storage/emulated/0/gms_termux.log