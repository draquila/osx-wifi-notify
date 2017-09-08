#!/bin/sh
AIRPORT_UTIL="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
TITLE="Wifi Notify"
MSG="Notifier started"
osascript -e "display notification \"$MSG\" with title \"$TITLE\""

while true; do
    DT=$(date +"%Y-%m-%d %H:%M:%S")
    TX=$($AIRPORT_UTIL -I | grep lastTxRate | cut -d: -f2 | sed 's/ //')
    if [ -z "$TX" ]; then
        echo "$DT no wifi signal"
    elif [ "$TX" -lt 150 ]; then
        MSG="$DT Weak wifi signal ($TX Mbps), resetting wifi!"
        osascript -e "display notification \"$MSG\" with title \"$TITLE\""
        networksetup -setairportpower en0 off
        sleep 3
        networksetup -setairportpower en0 on
    else
        echo "$DT wifi OK ($TX Mbps)"
    fi
    sleep 10
done
