#!/bin/bash

xvfb-daemon-run /opt/IBC/scripts/displaybannerandlaunch.sh &
# Tail latest in log dir
sleep 1
tail -f $(find $LOG_PATH -maxdepth 1 -type f -printf "%T@ %p\n" | sort -n | tail -n 1 | cut -d' ' -f 2-) &

if [ $TRADING_MODE == "live" ];then
    port=4001
else
    port=4002
fi

# Give enough time for a connection before trying to expose on 0.0.0.0:4003
sleep 30
echo "Forking :::$port onto 0.0.0.0:4003\n"
socat TCP-LISTEN:4003,fork TCP:127.0.0.1:4002
