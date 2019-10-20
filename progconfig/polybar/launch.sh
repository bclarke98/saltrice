#!/bin/bash
# ./launch.sh 0 : kills ('hides') polybar, ./launch.sh or ./launch.sh 1 restarts it
killall -q polybar; [[ -z $1 || $1 -eq 1 ]] && while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done && polybar example&
