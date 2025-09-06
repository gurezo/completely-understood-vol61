#!/bin/bash

# ローカルでDockerコンテナをテストするスクリプト

set -e

echo "🔨 Building Docker image locally..."
docker build --platform linux/arm64 -t backend-test:latest .

echo "🚀 Running container locally..."
docker run --rm -p 8080:8080 \
    -e PORT=8080 \
    -e RUST_LOG=info \
    -e CORS_ALLOWED_ORIGINS="http://127.0.0.1:5002,http://localhost:5002,http://127.0.0.1:4200,http://localhost:4200,https://completely-understood-vo-a0f23.web.app" \
    backend-test:latest &

CONTAINER_PID=$!

echo "⏳ Waiting for container to start..."
sleep 10

echo "🔍 Testing health check..."
if curl -f http://localhost:8080/ > /dev/null 2>&1; then
    echo "✅ Health check passed!"
else
    echo "❌ Health check failed!"
    echo "Container logs:"
    docker logs $(docker ps -q --filter ancestor=backend-test:latest) 2>/dev/null || echo "No container logs available"
fi

echo "🧹 Cleaning up..."
kill $CONTAINER_PID 2>/dev/null || true
docker stop $(docker ps -q --filter ancestor=backend-test:latest) 2>/dev/null || true
