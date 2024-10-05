#!/bin/bash

# Argumentos del script
nom=$1
tipoSo=$2
cpus=$3
memoriaRam=$4
memoriaDeVideo=$5
tamDiscoDuro=$6
rutaImagenIso=$7

# Crea la máquina virtual
VBoxManage createvm --name "$nom" --ostype "$tipoSo" --register

# Agregamos la cantidad de cpus, ram y vram a la máquina virtual
VBoxManage modifyvm "$nom" --cpus "$cpus" --memory "$memoriaRam" --vram "$memoriaDeVideo"

# Configurar la red virtual
VBoxManage modifyvm "$nom" --nic1 nat

# Crear el disco duro virtual
VBoxManage createhd --filename "/home/gemma/maquinas/$nom/$nom.vdi" --size "$tamDiscoDuro" --variant Standard

# Agregamos el controlador SATA del disco virtual
VBoxManage storagectl "$nom" --name "SATA Controller" --add sata --bootable on

# Conectar el disco duro virtual al controlador SATA
VBoxManage storageattach "$nom" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "/home/gemma/maquinas/$nom/$nom.vdi"

# Añadimos el controlador IDE
VBoxManage storagectl "$nom" --name "IDE Controller" --add ide

# Agregamos la imagen ISO al controlador IDE
VBoxManage storageattach "$nom" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$rutaImagenIso"

# Permitimos la visualización 
VBoxManage modifyvm "$nom" --vrde on

# Mostrar la información de la configuración de la VM
VBoxManage showvminfo "$nom"