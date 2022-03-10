#!/bin/sh
SERVICE="sleep_loop.sh"
MAX_RETRIES=5
SLEEP_TIME=2
PID=$(pgrep "$SERVICE")

echo "Service to stop $SERVICE" > /proc/1/fd/1

for i in $(seq 1 $MAX_RETRIES); do
    TIMESTAMP=$(date +%T)
	echo "Service to stop Timestamp: $TIMESTAMP" > /proc/1/fd/1
    if pgrep "$SERVICE" >/dev/null; then
        echo "LINE1: $TIMESTAMP $SERVICE pid $PID is still running - sending SIGTERM" > /proc/1/fd/1
        pkill -SIGTERM "$PID" #asynchronous process;
        sleep $SLEEP_TIME
        echo "$TIMESTAMP: $SERVICE, pid $PID pkill attempted" > /proc/1/fd/1
    else
        echo "$TIMESTAMP: $SERVICE, pid $PID finished running" > /proc/1/fd/1
        exit
    fi
done

POST_TIMESTAMP=$(date +%T)
echo "Post Timestamp: $POST_TIMESTAMP" > /proc/1/fd/1

if pgrep -f "$SERVICE" >/dev/null; then
    echo "$POST_TIMESTAMP: $SERVICE pid $PID is still running after $MAX_RETRIES retries with $SLEEP_TIME seconds sleep between each retry" > /proc/1/fd/1
else
    logger "$POST_TIMESTAMP: $SERVICE pid $PID finished running" 2>&1
fi
echo "Done Prestop Testing" > /proc/1/fd/1
