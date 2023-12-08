#!/bin/sh
if [ -z $DELAY ]; then sleep 0; else sleep 60; fi
if ! test -f /app/foundryvtt.zip; then
    wget -O /app/foundryvtt.zip "${TIMED_URL}"
else 
    echo "FoundryVTT already downloaded"
fi

if ! test -f /app/foundryvtt/done; then
    unzip /app/foundryvtt.zip -d /app/foundryvtt \
#    && cd foundrydata \
#    && ln -s /app/foundryshare Data/shared \
    && touch /app/foundryvtt/done
else
    echo "FoundryVTT already unzipped"
fi
