#!/bin/bash

IMAGE_NAME="dev"
CONTAINER_NAME="dev"

# Check Container
if toolbox list | grep -q $CONTAINER_NAME; then
    echo "🗑️  Removing old container $CONTAINER_NAME..."
    toolbox rm $CONTAINER_NAME
fi

if podman images | grep -q $IMAGE_NAME; then
    echo "🗑️  Removing old image $IMAGE_NAME..."
    podman rmi localhost/$IMAGE_NAME
fi

# Create Container
echo "📦 Building image $IMAGE_NAME..."
podman build -t $IMAGE_NAME .

if toolbox list | grep -q $CONTAINER_NAME; then
    echo "🗑️  Removing old container $CONTAINER_NAME..."
    toolbox rm $CONTAINER_NAME
fi

echo "🚀 Creating new toolbox $CONTAINER_NAME..."
toolbox create --container $CONTAINER_NAME --image $IMAGE_NAME

echo "🎉 Entering toolbox $CONTAINER_NAME..."
toolbox enter $CONTAINER_NAME



