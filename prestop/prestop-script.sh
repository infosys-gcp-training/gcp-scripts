#!/bin/sh
echo "echo hello > /proc/1/fd/1 " > /proc/1/fd/1
sleep 2
wait
echo "Done Prestop Testing" > /proc/1/fd/1
