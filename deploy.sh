#!/bin/bash
ENV=$1

docker stop my-react-$ENV || true
docker rm my-react-$ENV || true

if [ "$ENV" == "dev" ]; then
  ENVIRONMENT=dev docker-compose up -d --build
elif [ "$ENV" == "prod" ]; then
  ENVIRONMENT=prod docker-compose up -d --build
else
  echo "Unknown environment: $ENV"
  exit 1
fi