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
                                END {printf "%-*s %-*s %-*s\n",path_length, "RUTA",name_length, "NOMBRE",size_length, "TAMAÑO(B)";
                                        print current_largest_path, current_largest_name, current_largest_size;
                                        }'
        else
            echo -e "\nEl disco/directorio/filesystem está vacío."
        fi
    else
        echo -e "\nEl disco/directorio/filesystem no existe."
    fi    
}

# function getAvailableMemoryMainAndSwap
# Returns the total (bytes) and used (bytes and %)
# main and swap memory.
getAvailableMemoryMainAndSwap(){
    free | awk 'BEGIN {total_main=0; used_main=0; pct_used_main=0; total_swap=0; used_swap=0; pct_used_swap=0}
                $1=="Mem:"{total_main=$2; used_main=$3; pct_used_main=(used_main/total_main)*100}
                $1=="Swap:"{total_swap=$2; used_swap=$3; pct_used_swap=(used_swap/total_swap)*100}
                END {bytes_length = (total_main>total_swap)?length(sprintf("%d", total_main)):length(sprintf("%d", total_swap))}
                END {bytes_length += 3 }                
                END {printf "%-10s %-*s %-*s %-7s\n","     ",bytes_length,"TOTAL(B)",bytes_length,"EN USO(B)","EN USO(%)"}
                END {printf "%-10s %-*d %-*d %-7.1f\n","Principal:",bytes_length,total_main,bytes_length,used_main,pct_used_main}
                END {printf "%-10s %-*d %-*d %-7.1f\n","Swap:",bytes_length,total_swap,bytes_length,used_swap,pct_used_swap}'
}      

# function getCountActiveNetworkConnections
# Returns the number of active network connections.
getCountActiveNetworkConnections(){
    ss | awk 'BEGIN {total_established=0}
                   $2=="ESTAB"{total_established += 1}
                   END {print "\nTotal conexiones de red activas:",total_established}'
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
			
            getAvailableMemoryMainAndSwap
            ;;

		5)
			getCountActiveNetworkConnections
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
