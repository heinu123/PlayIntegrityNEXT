if [ -f "/storage/emulated/0/gms_termux.log" ]; then
  rm "/storage/emulated/0/gms_termux.log" 

touch /storage/emulated/0/gms_termux.log

su

su -c '{
  if [ -f /data/adb/pif.json ]; then
    rm "/data/adb/pif.json"
    echo "File /data/adb/pif.json removed."
  else
    echo "pif.json not present, let's continue"
  fi
}' >> /storage/emulated/0/gms_termux.log

su -c '{
  if pgrep -f com.google.android.gms > /dev/null; then
    pkill -f com.google.android.gms
    echo "com.google.android.gms process killed."
  else
    echo "com.google.android.gms process is not running."
  fi
}' >> /storage/emulated/0/gms_termux.log

su -c '{
  if pgrep -f com.google.android.gms.unstable > /dev/null; then
    pkill -f com.google.android.gms.unstable
    echo "com.google.android.gms.unstable process killed." 
  else
    echo "com.google.android.gms.unstable process is not running, no need to kill." 
  fi
}' >> /storage/emulated/0/gms_termux.log

cat /storage/emulated/0/gms_termux.log

# rm /storage/emulated/0/gms_termux.log