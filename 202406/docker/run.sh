#!/bin/bash

# Ejecutar el contenedor usando la imagen construida (crea la imagen luego del build)
docker run -d -p 8080:80 agussffernandez/web1-fernandez
