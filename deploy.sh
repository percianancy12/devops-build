#!/bin/bash
ENV=$1

# Stop & remove any old container
docker stop my-react-dev || true
docker rm my-react-dev || true
docker stop my-react-prod || true
docker rm my-react-prod || true

# Run new container with docker-compose
ENVIRONMENT=$ENV docker-compose up -d --build