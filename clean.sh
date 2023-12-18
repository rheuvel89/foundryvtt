#!/bin/sh
# This script is used to clean the docker containers, images and volume locations
# Use at your own risk!
docker system prune -a
docker volume prune -a
rm /usr/share/foundry* -r