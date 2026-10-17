#!/bin/bash
# Sonora Music Server - Inicio Local (Mac/Linux)

cd "$(dirname "$0")"

echo "========================================"
echo "  Sonora Music Server - Inicio Local"
echo "========================================"
echo

# Verificar si Node.js está instalado
if ! command -v node &> /dev/null; then
    echo "ERROR: Node.js no está instalado."
    echo "Instálalo desde https://nodejs.org/"
    exit 1
fi

# Verificar si ffmpeg está instalado
if ! command -v ffmpeg &> /dev/null; then
    echo "ADVERTENCIA: ffmpeg no está instalado."
    echo "Las descargas de YouTube funcionarán pero sin conversión a MP3."
    echo "Instala ffmpeg:"
    echo "  macOS:   brew install ffmpeg"
    echo "  Ubuntu:  sudo apt install ffmpeg"
    echo
fi

# Verificar si yt-dlp está instalado
if ! command -v yt-dlp &> /dev/null; then
    echo "ADVERTENCIA: yt-dlp no está instalado."
    echo "Para descargar de YouTube, instala yt-dlp:"
    echo "  npm install -g yt-dlp"
    echo "  o:   pip install yt-dlp"
    echo
fi

# Crear directorio de música si no existe
mkdir -p music

# Copiar .env si no existe
if [ ! -f ".env" ]; then
    echo "Creando archivo .env desde .env.example..."
    cp .env.example .env
fi

echo
echo "Iniciando servidor en puerto 3000..."
echo "Presiona Ctrl+C para detener el servidor."
echo "========================================"
echo

node server.js
