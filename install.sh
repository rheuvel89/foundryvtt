#!/bin/sh

# This script is used to install the docker-compose file and start the containers

# Split the subs lista and create the docker-compose.yml file
SUBLIST=$0
SUBS=$(echo $SUBLIST | tr ";" "\n")

cat docker-compose.start.yml | sed 's|${SUBLIST}|'${SUBLIST}'|g' > docker-compose.yml

for SUB in $SUBS
do
    cat docker-compose.instance.yml | sed 's|${LOCATION_SUB}|'${SUB}'|g' >> docker-compose.yml
done

# Install docker and docker-compose
if [ $(dpkg-query -W -f='${Status}' docker 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  apt-get update
  apt-get install -y ca-certificates curl gnupg
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  chmod a+r /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-get update
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  apt-get install -y docker-compose
fi

# Pull the images and start the containers
docker-compose pull --env-file default.env
docker-compose up --env-file default.env -d