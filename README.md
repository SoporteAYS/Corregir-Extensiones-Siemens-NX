# Añadido script para configurar asociación de archivos .PRT

Este commit agrega un script en batch para configurar la asociación de archivos con extensión .PRT al programa Siemens NX. El script busca la variable de entorno UGII_BASE_DIR en el Registro del sistema y utiliza esa variable para asociar los archivos .PRT con Siemens NX. También vincula un icono al programa.

Cambios realizados:
- Se agregó el script para configurar la asociación de archivos .PRT.
- El script busca la variable de entorno UGII_BASE_DIR y utiliza su valor.
- Asocia la extensión .PRT con el programa Siemens NX.
- Vincula un icono al programa.
