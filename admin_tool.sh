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
# Despliega la ruta, el nombre y el tamaño del archivo más grande
# de un disco, filesystem o directorio.
getLargestFileInDiskOrFilesystem(){
    if ( test -d "$1" ) then
        if !(test -z "$(ls -A "$1")") then
            ls -lRA "$1" | awk -v path=$1  'BEGIN {current_dir=""}
                                BEGIN {current_largest_name=""}
                                BEGIN {current_largest_path=""}
                                BEGIN {current_largest_size=0}
                                substr($1,1,length(path))==path { current_dir=substr($1,1,length($1)-1) }
                                NF==9 && length($1)==10 && substr($1,1,1)!="d" && current_largest_size<$5 {
                                        current_largest_size=$5; current_largest_name=$9; current_largest_path=current_dir"/";
                                        }
                                END {path_length=length(current_largest_path)}
                                END {name_length=length(current_largest_name)}
                                END {size_length=length(current_largest_size)}
                                END {printf "%-*s %-*s %-*s\n",path_length, "PATH",name_length, "NAME",size_length, "SIZE(B)";
                                        print current_largest_path, current_largest_name, current_largest_size;
                                        }'
        else
            echo -e "\nEl disco/directorio/filesystem está vacío."
        fi
    else
        echo -e "\nEl disco/directorio/filesystem no existe."
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
    echo -e "\nPor favor seleccione la operación que desea realizar:"
    read -p ">>> " opcion

	case $opcion in
		1)
            getTop5CPUProcesses
			;;

		2)
			getConnectedDisksAndFilesystems
			;;

		3)
            echo "Escriba la ruta del directorio/disco/filesystem de su interés:"
            read -p ">>> " path
            echo ""
			getLargestFileInDiskOrFilesystem $path
            ;;

		4)
			echo 4
            ;;

		5)
			echo 5
			;;

		0)
            exit 0
            ;;
		*)
			echo -e  '\nOpción no válida. Intente de nuevo.\n'
            ;;
	esac
    echo -e -n '\nPresione enter para continuar ... '
    read sink
done
