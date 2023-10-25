@echo off
chcp 65001 > nul

:: Script para configurar la asociación de archivos .PRT en Siemens NX
:: Este script busca la variable de entorno UGII_BASE_DIR en el Registro del sistema,
:: luego utiliza esta variable para asociar los archivos .PRT con el programa Siemens NX
:: y vincula un icono al programa.

setlocal enabledelayedexpansion

rem Mensaje informativo
echo ******************************************************
echo ** Buscando la variable de entorno UGII_BASE_DIR... **
echo ******************************************************

rem Obtener el valor de UGII_BASE_DIR desde la variable de entorno del sistema
for /f "tokens=2*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v UGII_BASE_DIR ^| find "UGII_BASE_DIR"') do (
    set "UGII_BASE_DIR=%%j"
)

if not defined UGII_BASE_DIR (
    echo La variable de entorno UGII_BASE_DIR no está configurada. Por favor, configure la variable de entorno y luego ejecute este script nuevamente.
    pause
    exit /b 1
)

rem Ruta al programa
set programa="%UGII_BASE_DIR%\NXBIN\ugs_router.exe"

rem Ruta a la extensión .PRT
set extension=.PRT

rem Ruta al icono
set iconPath="%UGII_BASE_DIR%\UGII\nx.ico"

rem Mostrar información de manera clara
echo ** UGII_BASE_DIR encontrado: %UGII_BASE_DIR%
echo ** Ruta al programa: %programa%
echo ** Ruta a la extensión: %extension%
echo ** Ruta al icono: %iconPath%
echo ****************************************************
echo.

rem Verificar si ya está configurada
assoc | findstr %extension%
if errorlevel 1 (
    echo ****************************************************
    echo ** Asociar la extensión con el programa...        **
    echo ****************************************************
    rem Asociar la extensión con el programa
    assoc %extension%=SiemensPRT
) else (
    echo La extensión %extension% ya está asociada con SiemensPRT.
)

rem Configurar el programa para abrir la extensión y vincular el icono
set "SiemensPRT=%programa% -ug "%%1""
ftype SiemensPRT=%SiemensPRT%
reg add "HKEY_CLASSES_ROOT\Applications\ugs_router.exe\DefaultIcon" /ve /d %iconPath% /f > nul

echo.
echo ****************************************************
echo ** Configuración completada.                      **
echo ****************************************************
pause

endlocal
