@echo off
cd /d "%~dp0"

echo ========================================
echo  Sonora Music Server - Inicio Local
echo ========================================
echo.

:: Verificar si Node.js está instalado
where node >nul 2>&1
if errorlevel 1 (
    echo ERROR: Node.js no esta instalado o no esta en el PATH.
    echo Por favor instala Node.js desde https://nodejs.org/
    pause
    exit /b 1
)

:: Verificar si ffmpeg está instalado
where ffmpeg >nul 2>&1
if errorlevel 1 (
    echo ADVERTENCIA: ffmpeg no esta instalado.
    echo Las descargas de YouTube funcionaran pero sin conversion a MP3.
    echo Para descargas completas, instala ffmpeg:
    echo   https://ffmpeg.org/download.html
    echo.
)

:: Verificar si yt-dlp está instalado
where yt-dlp >nul 2>&1
if errorlevel 1 (
    echo ADVERTENCIA: yt-dlp no esta instalado.
    echo Para descargar de YouTube, instala yt-dlp:
    echo   winget install yt-dlp
    echo   o: npm install -g yt-dlp
    echo.
)

:: Crear directorio de musica si no existe
if not exist "music" mkdir music

:: Copiar .env si no existe
if not exist ".env" (
    echo Creando archivo .env desde .env.example...
    copy .env.example .env
)

echo.
echo Iniciando servidor en puerto 3000...
echo Presiona Ctrl+C para detener el servidor.
echo ========================================
echo.

node server.js

pause
