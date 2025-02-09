#!/bin/bash

FILE="/root/output.txt"
LOG="/root/access.log"
DURATION=120
> "$LOG"

inotifywait -m -e modify "$FILE" --format '%T %w%f' --timefmt '%s' | while read -r timestamp file; do
    lsof "$FILE" | awk '{print $2}' | grep -v PID >> "$LOG" 
done &

sleep $DURATION
pkill -P  $$ inotifywait

PID=$(sort "$LOG" | uniq -c | sort -nr | head -n 1 | awk '{print $2}')

echo "$PID" > /root/answer.txt

echo "kurwa work"
