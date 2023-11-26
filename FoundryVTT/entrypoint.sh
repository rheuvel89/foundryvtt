#!/bin/sh

if ! test -f /app/foundryvtt.zip; then
    wget -O /app/foundryvtt.zip "${TIMED_URL}"
else 
    echo "FoundryVTT already downloaded"
fi

if ! test -f /app/foundryvtt/done; then
    unzip /app/foundryvtt.zip -d /app/foundryvtt
    touch /app/foundryvtt/done
else
    echo "FoundryVTT already unzipped"
fi

echo "###########"
ls /
echo "###########"
ls /app/
echo "###########"
ls /app/foundryvtt/
echo "###########"
ls /app/foundryvtt/resources/
echo "###########"
ls /app/foundryvtt/resources/app/
echo "###########"
node /app/foundryvtt/resources/app/main.js --dataPath=/app/foundrydata
