#!/bin/bash
ENV=$1

if [ "$ENV" == "dev" ]; then
  ENVIRONMENT=dev docker-compose up -d --build
elif [ "$ENV" == "prod" ]; then
  ENVIRONMENT=prod docker-compose up -d
else
  echo "Unknown environment: $ENV"
  exit 1
fi