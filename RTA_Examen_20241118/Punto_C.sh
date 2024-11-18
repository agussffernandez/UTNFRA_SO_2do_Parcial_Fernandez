#!/bin/bash

# 1. Ir al directorio correcto donde están los scripts
cd /home/agustina/UTNFRA_SO_2do_Parcial_Fernandez/202406/docker

# 2. Construir la imagen Docker
echo "Construyendo la imagen Docker..."
./make-build.sh

# 3. Ejecutar el contenedor Docker
echo "Ejecutando el contenedor Docker..."
./run.sh

# 4. Verificar que el contenedor está corriendo
echo "Verificando que el contenedor esté corriendo..."
docker ps

# 5. Mensaje final
echo "La imagen y el contenedor han sido configurados correctamente."
echo "Puedes acceder a la página en: http://localhost:8080"
