#!/bin/bash

# Simple deployment script for Lua Chat Server
# For beginners - pulls latest images and restarts services

set -e

echo "Starting deployment of Lua Chat Server..."

# Check if Docker and Docker Compose are installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Pull latest images
echo "Pulling latest Docker images..."
docker-compose pull

# Stop existing services
echo "Stopping existing services..."
docker-compose down

# Build and start services
echo "Building and starting services..."
docker-compose up -d --build

# Wait for services to be ready
echo "Waiting for services to start..."
sleep 10

# Check if services are running
if docker-compose ps | grep -q "Up"; then
    echo "✅ Deployment successful! Chat server is running."
    echo "Server is available on localhost:8888"
else
    echo "❌ Deployment failed! Check logs with: docker-compose logs"
    exit 1
fi

# Show running services
echo "Current running services:"
docker-compose ps

echo "Deployment completed successfully!"
echo "Use 'docker-compose logs -f' to view logs"
echo "Use 'docker-compose down' to stop the server"