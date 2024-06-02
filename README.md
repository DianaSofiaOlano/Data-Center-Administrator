<p align="center">
  <h1 align="center">Administración de un Data Center 🏢</h1>
</p>
Este proyecto consta de dos herramientas diseñadas para facilitar las tareas de administración de un data center. Una herramienta está desarrollada en Powershell y la otra en BASH, ambas ofreciendo un conjunto de opciones para obtener información relevante sobre el sistema.

## Funcionalidades 📃🖋️
Ambas herramientas proporcionan un menú con las siguientes opciones:

+ **Top 5 Procesos de Consumo de CPU:** Muestra los cinco procesos que están consumiendo más CPU en ese momento.
+ **Listado de Filesystems o Discos Conectados:** Proporciona información sobre los filesystems o discos conectados a la máquina, incluyendo su tamaño y la cantidad de espacio libre en bytes.
+ **Archivo Más Grande en un Disco Específico:** Permite al usuario especificar un disco o filesystem y muestra el nombre, tamaño y trayectoria completa del archivo más grande almacenado en el.
+ **Memoria Libre y Espacio de Swap en Uso:** Ofrece la cantidad de memoria libre y la cantidad de espacio de swap en uso, tanto en bytes como en porcentaje.
+ **Número de Conexiones de Red Activas (ESTABLISHED):** Informa sobre el número de conexiones de red activas en estado ESTABLISHED.

## Requisitos previos ✔️
+ Permisos adecuados para ejecutar las herramientas.
+ Powershell (para la herramienta en Powershell).
+ Bash (para la herramienta en BASH).

## Despliegue local 💻🖱️
1. Clonar o descargar el repositorio
   
2. Para la herramienta en **Powershell**:
   - Abre una ventana de Powershell.
   - Asegúrate de que el archivo **admin_tool.ps1** tenga permisos de ejecución. Puedes otorgarlos con el siguiente comando **(Ejecuta el comando como administrador)**:
     ```bash
      Set-ExecutionPolicy Unrestricted
      ```
   - Navega hasta la ubicación donde se encuentra el archivo **admin_tool.ps1**.
      ```bash
      cd C:\Users\"Username"\Data-Center-Administrator
      ```
   - Ejecuta el archivo usando el comando:
      ```bash
      .\admin_tool.ps1
      ```
      
3. Para la herramienta en **BASH**:
   - Abre una terminal.
   - Navega hasta la ubicación donde se encuentra el archivo **admin_tool.sh**.
      ```bash
      cd C:\Users\"Username"\Data-Center-Administrator
      ```
   - Asegúrate de que el archivo **admin_tool.sh** tenga permisos de ejecución. Puedes otorgarlos con el siguiente comando:
      ```bash
      chmod +x admin_tool.sh
      ```
   - Ejecuta el archivo usando el comando:
      ```bash
      ./admin_tool.sh
      ```
      
## Autores 👨‍💻👩‍💻
+ [Juan Fernando Martínez](https://github.com/JuanF2019)
+ [Diana Sofia Olano](https://github.com/DianaSofiaOlano)
