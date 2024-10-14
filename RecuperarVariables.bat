@echo off
chcp 1252 > nul
:: Script mejorado para configurar la asociación de archivos .PRT en Siemens NX
setlocal enabledelayedexpansion

:menu
cls
echo ======================================================
echo    Script de Asociación de Archivos .PRT para NX
echo ======================================================
echo 1. Asociar archivos .PRT con NX
echo 2. Deshacer asociación de archivos .PRT
echo 3. Salir
echo.
set /p opcion="Seleccione una opción (1-3): "

if "%opcion%"=="1" goto asociar
if "%opcion%"=="2" goto desasociar
if "%opcion%"=="3" goto fin
goto menu

:asociar
echo Buscando la variable de entorno UGII_BASE_DIR...
for /f "tokens=2*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v UGII_BASE_DIR 2^>nul ^| find "UGII_BASE_DIR"') do (
    set "UGII_BASE_DIR=%%j"
)
if not defined UGII_BASE_DIR (
    echo Error: La variable de entorno UGII_BASE_DIR no está configurada.
    echo Configure la variable de entorno y luego ejecute este script nuevamente.
    pause
    goto menu
)

set "programa=%UGII_BASE_DIR%\NXBIN\ugs_router.exe"
set "extension=.PRT"
set "iconPath=%UGII_BASE_DIR%\UGII\nx.ico"

echo UGII_BASE_DIR encontrado: %UGII_BASE_DIR%
echo Ruta al programa: %programa%
echo Ruta a la extensión: %extension%
echo Ruta al icono: %iconPath%

if not exist "%programa%" (
    echo Error: No se encuentra el archivo ugs_router.exe en la ruta especificada.
    echo Verifique la instalación de NX y la variable UGII_BASE_DIR.
    pause
    goto menu
)

assoc %extension% | findstr /i "SiemensPRT" >nul
if %errorlevel% neq 0 (
    echo Asociando la extensión %extension% con SiemensPRT...
    assoc %extension%=SiemensPRT
    if %errorlevel% neq 0 (
        echo Error: No se pudo asociar la extensión %extension% con SiemensPRT.
        pause
        goto menu
    )
) else (
    echo La extensión %extension% ya está asociada con SiemensPRT.
)

set "SiemensPRT=%programa% -ug "%%1""
ftype SiemensPRT=%SiemensPRT%
if %errorlevel% neq 0 (
    echo Error: No se pudo configurar el tipo de archivo SiemensPRT.
    pause
    goto menu
)

reg add "HKEY_CURRENT_USER\Software\Classes\Applications\ugs_router.exe\DefaultIcon" /ve /d "%iconPath%" /f >nul
if %errorlevel% neq 0 (
    echo Error: No se pudo agregar el icono al registro.
    pause
    goto menu
)

echo.
echo Configuración completada exitosamente.
pause
goto menu

:desasociar
echo Deshaciendo la asociación de archivos .PRT...
assoc .PRT=
if %errorlevel% neq 0 (
    echo Error: No se pudo deshacer la asociación de archivos .PRT.
) else (
    echo La asociación de archivos .PRT ha sido eliminada.
)
pause
goto menu

:fin
echo Gracias por usar el script. ¡Hasta luego!
endlocal
exit /b 0
