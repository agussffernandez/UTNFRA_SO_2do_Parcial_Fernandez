#!/bin/bash

# Cambiar al directorio donde está el proyecto de Ansible
cd /home/agustina/UTNFRA_SO_2do_Parcial_Fernandez/202406/ansible

# Ejecutar el playbook de Ansible
ansible-playbook -i inventory/hosts playbook.yml
