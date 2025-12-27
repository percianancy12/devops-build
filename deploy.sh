#!/bin/bash
ENV=$1

echo "Starting deployment for environment: $ENV"

# Stop & remove any old container (dev or prod)
if docker ps -q -f name=my-react-dev; then
  echo "Stopping my-react-dev..."
  docker stop my-react-dev
  docker rm my-react-dev
fi

if docker ps -q -f name=my-react-prod; then
  echo "Stopping my-react-prod..."
  docker stop my-react-prod
  docker rm my-react-prod
fi

# Run new container with docker-compose
echo "Launching my-react-$ENV..."
ENVIRONMENT=$ENV docker-compose up -d --build

# Verify container is running
docker ps -f name=my-react-$ENV