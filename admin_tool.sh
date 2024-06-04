#!/bin/bash

# function getTop5CPUProcesses
# Despliega el id, % CPU, usuario y comando de los 
# 5 procesos que mas CPU consumen al momento del llamado.
getTop5CPUProcesses(){
    ps -eo pid,pcpu,user,comm --sort -pcpu | head -6
}

# function getConnectedDisksAndFilesystems
# Despliega el nombre, bytes disponibles, bytes totales y punto de montaje
# de los discos o filesystems conectados a la máquina.
getConnectedDisksAndFilesystems(){
    df --block-size=1 --output=source,avail,size,target
}

# function getLargestFileInDiskOrFilesystem
# Despliega el nombre, tamaño y ruta del archivo más grande
# de un disco, filesystem o directorio.
getLargestFileInDiskOrFilesystem(){
    if (ls -d $path) then
        ls -lRA "$1"

        #revisar primera letra que no sea d Ej - con awk
        #usar script del parcial para la ruta completa y mezclar lo de arriba

        # user=$(whoami)
        # ls -lR /home | awk -v user=$user 'BEGIN {current_dir=""}
		# 		  substr($1,1,5)=="/home"\
		# 		      {current_dir=substr($1,1,length($1)-1)}
		# 		  $3==user {if(substr($1,4,1)=="x") print current_dir"/"$9}' 

    else
        echo "El disco/directorio/filesystem no existe o no tiene archivos."
    fi    
}

until [ "$opcion" == "0" ]
do
    echo -e "\nADMINISTRACIÓN DEL DATA CENTER\n"
    echo "1. Desplegar los cinco procesos que más CPU estén consumiendo en ese momento"
    echo "2. Desplegar los filesystems o discos conectados a la máquina"
    echo "3. Desplegar el nombre y el tamaño del archivo más grande almacenado en un disco o filesystem"
    echo "4. Cantidad de memoria libre y cantidad del espacio de swap en uso"
    echo "5. Número de conexiones de red activas actualmente (en estado ESTABLISHED)"
    echo "0. Salir"
         
    read -p ">>> " opcion

	case $opcion in
		1)
            getTop5CPUProcesses
			;;

		2)
			getConnectedDisksAndFilesystems
			;;

		3)
            echo "Escriba la ruta del directorio/disco/filesystem de su interés"
            read -p ">>> " path
			getLargestFileInDiskOrFilesystem $path
            ;;

		4)
			echo 4
            ;;

		5)
			echo 5
			;;

		0)
            echo "=================================="
            echo "            Saliendo              "
            echo "=================================="
            exit 0
            ;;
		*)
			echo -e  '\nOpción no válida. Intente de nuevo.\n'
            ;;
	esac
    echo -e -n '\nPresione enter para continuar ... '
    read sink
done
