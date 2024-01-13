if [ -f /data/adb/pif.json ]  
then
    su -c "rm "/data/adb/pif.json""
else
   echo "OK"
fi

{ if pgrep -f com.google.android.gms > /dev/null; then
  su -c "pkill -f com.google.android.gms && echo "com.google.android.gms process killed."";
else
  echo "com.google.android.gms process is not running.";
fi; } && { if pgrep -f com.google.android.gms.unstable > /dev/null; then
  su -c "pkill -f com.google.android.gms.unstable && echo "com.google.android.gms.unstable process killed."";
else
  echo "com.google.android.gms.unstable process is not running, no need to kill.";
fi; }