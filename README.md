# curso_osvvm
Para el curso es necesario clonar el repositorio OsvvmLibraries dentro del directorio osvvm.
Pasos:
1) crear el directorio osvvm
2) dentro de osvvm ejecutar  git clone --recursive https://github.com/OSVVM/OsvvmLibraries.git
3) abrir el archivo  OsvvmSettingDefault.tcl, que esta en OsvvmLibraries/Scripts y agregar
   la siguiente linea SetVHDLVersion 2008 al final del archivo antes del cierre del namespace.
   Esto lo hacemos porque la version de Questa 2025 marca como no compatible el codigo VHDL-2019 del RandomPkg2019.vhd

4) Crear dentro de osvvm el directorio curso_osvvm
    

Estructura de directorios para el curso
osvvm
  OsvvmLibraries
    osvvm
    Scripts
    osvvm_lib
    .
    .
    .
    
  curso_osvvm
    Ejercicio 1
      tb
      rtl
      sim
    Ejercicio 2
      tb
      .
      .
