#!/bin/bash

count=0
sleepTime=10

while true; do
    sleep $sleepTime &
    count=$(( count + 1 ))
    printf 'Test script count: %d\n' "$count" > /proc/1/fd/1
	wait
done

