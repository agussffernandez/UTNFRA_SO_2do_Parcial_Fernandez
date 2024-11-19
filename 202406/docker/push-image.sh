#!/bin/bash

# Asegúrate de que la imagen que deseas pushear existe
IMAGE_NAME="agussffernandez/web1-fernandez:latest"

# Iniciar sesión en Docker Hub

# Pushear la imagen a Docker Hub
echo "Pusheando la imagen $IMAGE_NAME a Docker Hub..."
docker push $IMAGE_NAME
