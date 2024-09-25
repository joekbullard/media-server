#!/bin/bash

# Navigate to the directory containing your docker-compose.yml file
cd /home/homeserver/media-docker/docker-compose.yml

# Pull the latest images
docker compose pull

# Rebuild and restart the containers
docker compose up -d --build

# Optional: Add logging or notifications if needed
echo "Docker Compose updated successfully on $(date)" >> /var/log/docker-compose-update.log
