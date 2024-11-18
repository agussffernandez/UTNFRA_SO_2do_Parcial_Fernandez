#!/bin/bash
# Esta NO es la ubicacion/direccion que se usa en el script del punto B, sino que es una copia del script para que de pueda ver lo que contiene. LA RUTA DEL SCRIPT DEL PUNTO B ES OTRA (/usr/local/bin/FernandezAltaUser-Groups.sh), LA QUE PIDE LA CONSIGNA.

# Parametros de entrada
usuario_base=$1  # El nombre del usuario cuya contraseña se asignará a los nuevos usuarios.
archivo_usuarios=$2  # La ruta del archivo donde está Lista-Usuarios.txt.

# Obtener la contraseña cifrada del usuario base
usuario_clave=$(grep "^$usuario_base:" /etc/shadow | awk -F ':' '{print $2}')

# Exportar la variable usuario_clave para que sea accesible en el subproceso
export usuario_clave

# Uso de xargs para procesar el archivo de Lista-Usuarios.txt
cat "${archivo_usuarios}" | grep -v "^#" | xargs -I {} bash -c '
	# Variables pasadas al subproceso
        usuario_clave="'$usuario_clave'"

        # Extracción de los campos de la línea: nombre_usuario, grupo_primario y directorio_home
        nombre_usuario=$(echo {} | cut -d "," -f1)
        grupo_primario=$(echo {} | cut -d "," -f2)
        directorio_home=$(echo {} | cut -d "," -f3)

        # Creación del grupo
        groupadd "$grupo_primario"

        # Crear el directorio home para cada usuario
        mkdir -p "$directorio_home"
        chown "$nombre_usuario:$grupo_primario" "$directorio_home"
        chmod 700 "$directorio_home"

        # Crear el usuario con la contraseña del usuario base
        useradd -m -s /bin/bash -c "$nombre_usuario" -g "$grupo_primario" "$nombre_usuario"

        # Asignar la contraseña cifrada al usuario
        echo "$nombre_usuario:$usuario_clave" | chpasswd
'

# Mensaje final
echo "Usuarios creados exitosamente."

