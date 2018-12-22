#!/bin/bash

xvfb-daemon-run /opt/IBC/scripts/displaybannerandlaunch.sh &
# Tail latest in log dir
sleep 1
tail -f $(find $LOG_PATH -maxdepth 1 -type f -printf "%T@ %p\n" | sort -n | tail -n 1 | cut -d' ' -f 2-) &

# case $(echo $TRADING_MODE | sed -r "s/.*/\U&\E/") in
# "LIVE" )
#     case $(echo $APP | sed -r "s/.*/\U&\E/") in
#     "GATEWAY" )        port=4001        ;;
#     "TWS" )        port=7496        ;;
#     * )        port=-1        ;;
#     esac    ;;
# "PAPER" )
#     case $(echo $APP | sed -r "s/.*/\U&\E/") in
#     "GATEWAY" )        port=4002        ;;
#     "TWS" )        port=7497        ;;
#     * )        port=-1        ;;
#     esac    ;;
# * )
#     port=-1    ;;
# esac

port=-1
case $(echo $APP | sed -r "s/.*/\U&\E/") in
"GATEWAY" )
    case $(echo $TRADING_MODE | sed -r "s/.*/\U&\E/") in
    "LIVE" )        port=4001        ;;
    "PAPER" )        port=4002        ;;
    esac;;
"TWS" )
    case $(echo $TRADING_MODE | sed -r "s/.*/\U&\E/") in
    "LIVE" )        port=7496        ;;
    "PAPER" )        port=7497        ;;
    esac;;
esac

echo "APP=$APP,TRADING_MODE=$TRADING_MODE,port=$port"
if [ $port -eq -1 ]; then echo "!!! valid TRADING_MODE: [LIVE|PAPER]\nvalid APP: [GATEWAY|TWS] (case insensitive)"; fi

# Give enough time for a connection before trying to expose on 0.0.0.0:4003
sleep 30
echo "Forking :::$port onto 0.0.0.0:4003\n"
socat TCP-LISTEN:4003,fork TCP:127.0.0.1:$port