#!/bin/bash
set -euo pipefail

APP_NAME="fd-practice"
IMAGE_TAG="${1:-latest}"
REGISTRY="ghcr.io/example"

echo "Deploying ${APP_NAME}:${IMAGE_TAG}"

echo "Building Docker image..."
docker build -t "${REGISTRY}/${APP_NAME}:${IMAGE_TAG}" .

echo "Pushing to registry..."
docker push "${REGISTRY}/${APP_NAME}:${IMAGE_TAG}"

echo "Updating deployment..."
kubectl set image "deployment/${APP_NAME}" \
  app="${REGISTRY}/${APP_NAME}:${IMAGE_TAG}"

echo "Waiting for rollout..."
kubectl rollout status "deployment/${APP_NAME}" --timeout=120s

echo "Deployment complete!"
