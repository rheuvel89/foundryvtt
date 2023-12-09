#!/bin/sh
SUBLIST=$0
SUBS=$(echo $SUBLIST | tr ";" "\n")

cat docker-compose.start.yml | sed 's|${SUBLIST}|'${SUBLIST}'|g' > docker-compose.yml

for SUB in $SUBS
do
    cat docker-compose.instance.yml | sed 's|${LOCATION_SUB}|'${SUB}'|g' >> docker-compose.yml
done

echo "volumes:" >> docker-compose.yml
for SUB in $SUBS
do
    echo "  foundrydata_${SUB}:" >> docker-compose.yml
done
