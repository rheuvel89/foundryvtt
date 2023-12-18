#!/bin/sh

# This script is used to install the docker-compose file and start the containers

if command -v "curl" > /dev/null 2>&1; 
then
  echo "Curl is already installed"
else
  apt-get install -y ca-certificates curl
fi
mkdir foundryinstalltemp
curl -fsSl https://raw.githubusercontent.com/rheuvel89/foundryvtt/main/docker-compose.start.yml -o foundryinstalltemp/docker-compose.start.yml
curl -fsSl https://raw.githubusercontent.com/rheuvel89/foundryvtt/main/docker-compose.instance.yml -o foundryinstalltemp/docker-compose.instance.yml

# Split the subs lista and create the docker-compose.yml file
SUBLIST=$1
SUBS=$(echo $SUBLIST | tr ";" "\n")

cat foundryinstalltemp/docker-compose.start.yml | sed 's|${SUBLIST}|'${SUBLIST}'|g' > docker-compose.yml

for SUB in $SUBS
do
    cat foundryinstalltemp/docker-compose.instance.yml | sed 's|${LOCATION_SUB}|'${SUB}'|g' >> docker-compose.yml
done

# Install docker and docker-compose
if command -v "docker" > /dev/null 2>&1; 
then
  echo "Docker is already installed"
else
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
docker-compose --env-file default.env pull 
docker-compose --env-file default.env up -d

# Clean up
rm -rf foundryinstalltemp