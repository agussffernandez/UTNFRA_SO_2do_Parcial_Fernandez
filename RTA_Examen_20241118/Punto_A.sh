#!/bin/bash

# Variables de los discos
DISCO1="/dev/sde" #nombre del 1er disco de 2GB
DISCO2="/dev/sdd" #nombre del 2do disco de 1GB
# Variables de los volumenes de grupo (VG)
VG_DATOS="vg_datos"
VG_TEMP="vg_temp"
# Variables de los volumenes logicos (LV)
LV_DOCKER="lv_docker"
LV_WORKAREAS="lv_workareas"
LV_SWAP="lv_swap"

# 1. Limpiar los discos existentes
echo "Limpiando las particiones existentes..."
wipefs --all ${DISCO1}
wipefs --all ${DISCO2}

# 2. Paticion de discos
# Disco de 2GB para LVM
fdisk ${DISCO1}
#Le damos todo el espacio a la primer particion primaria
n
p



t #Le cambiamos el tipo de la particion a LVM
1
8E
w #Guardamos y salimos
# Disco de 1GB para swap
fdisk ${DISCO2}
n
p



t
1
82
w

# 3. Crear los volumenes fisicos para cada particion (PV)
echo "Creando los volumenes fisicos"
pvcreate ${DISCO1}1 ${DISCO2}1

# 4.Crear grupos de volumenes (VG)
echo "Creando los grupos de volumenes"
vgcreate ${VG_DATOS} ${DISCO1}1
vgcreate ${VG_TEMP} ${DISCO2}1
# 5. Crear los volumenes logicos (LV)
echo "Creando los volumenes logicos"
# LV para docker 1.5GB en vg_datos
lvcreate -L 1.5G ${VG_DATOS} -n ${LV_DOCKER}
# LV para workareas 500M en vg_datos
lvcreate -L 500M ${VG_DATOS} -n ${LV_WORKAREAS}
# LV para swap 512M en vg_temp
lvcreate -L 512M ${VG_TEMP} -n ${LV_SWAP}

# 6. Formatear los LV
echo "Formateo de volumenes logicos"
# Formatear los lv de docker y workareas con ext4
mkfs -t ext4 /dev/mapper/${VG_DATOS}-${LV_DOCKER}
mkfs -t ext4 /dev/mapper/${VG_DATOS}-${LV_WORKAREAS}
# Formatear el lv de swap como swap
mkswap /dev/mapper/${VG_TEMP}-${LV_SWAP}


# 7. Crear un punto de montaje para los lv de docker y workareas
mkdir -p /var/lib/docker
mkdir -p /home/desarrollo

# 8. Montar los LV
mount /dev/mapper/${VG_DATOS}-${LV_DOCKER} /var/lib/docker
mount /dev/mapper/${VG_DATOS}-${LV_WORKAREAS} /home/desarrollo
swapon /dev/mapper/${VG_TEMP}-${LV_SWAP}

# 9. Reiniciar el servicio Docker para que reconozca los nuevos volumenes logicos
echo "Reiniciando el servicio Docker para aplicar cambios"
systemctl restart docker
systemctl status docker # Verificamos que el docker este funcionando correctamente luego del reinicio

# 10. Finalizacion
echo "El proceso a finalizado con exito"
