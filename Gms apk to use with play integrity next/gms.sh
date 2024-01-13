#!/data/data/com.termux/files/home/local/bin/bash
#!/data/data/com.termux/files/usr/bin/bash
su -c "rm /data/adb/pif.json"
su -c "{ if pgrep -f com.google.android.gms > /dev/null; then pkill -f com.google.android.gms && echo "com.google.android.gms process killed."; else echo "com.google.android.gms process is not running."; fi; } && { if pgrep -f com.google.android.gms.unstable > /dev/null; then pkill -f com.google.android.gms.unstable && echo "com.google.android.gms.unstable process killed."; else echo "com.google.android.gms.unstable process is not running, no need to kill."; fi; }"