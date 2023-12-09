#!/bin/sh
if [ -z $DELAY ]; then sleep 0; else sleep 60; fi
if ! test -f /app/foundryvtt.zip; then
    wget -O /app/foundryvtt.zip "${TIMED_URL}"
else 
    echo "FoundryVTT already downloaded"
fi

if ! test -f /app/foundryvtt/done; then
    unzip /app/foundryvtt.zip -d /app/foundryvtt \
    && touch /app/foundryvtt/done
else
    echo "FoundryVTT already unzipped"
fi

if test -d /app/foundrydata/Data; then echo Data exists; else mkdir -p /app/foundrydata/Data; fi
if [ -L /app/foundrydata/Data/shared ]; then echo Link exists; else ln -s /app/foundryshare/ /app/foundrydata/Data/shared; fi

node /app/foundryvtt/resources/app/main.js --dataPath=/app/foundrydata
