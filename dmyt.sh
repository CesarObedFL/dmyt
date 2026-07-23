#!/bin/bash
# Script para descargar música de YouTube organizando por Artista y Disco

# 💡 Comando para instalar yt-dlp en Fedora:
# sudo dnf install yt-dlp ffmpeg

# Si se pasa un argumento, úsalo como URL; si no, pregunta
if [ -n "$1" ]; then
    PLAYLIST_URL="$1"
else
    read -p "Pega la URL de la playlist o video: " PLAYLIST_URL
fi

# Verificar que la URL no esté vacía
if [ -z "$PLAYLIST_URL" ]; then
    echo "❌ Error: No se proporcionó ninguna URL"
    exit 1
fi

# Pedir los datos de organización para la carpeta y etiquetas
read -p "Introduce el nombre del ARTISTA: " ARTISTA_INPUT
read -p "Introduce el nombre del DISCO / ÁLBUM: " DISCO_INPUT
read -p "Introduce el nombre del Genero:" GENERO_INPUT

# Validar que no se dejen vacíos para evitar rutas extrañas
if [ -z "$ARTISTA_INPUT" ] || [ -z "$DISCO_INPUT" ] || [ -z "$GENERO_INPUT" ]; then
    echo "❌ Error: El nombre del artista, del disco y del genero son obligatorios para organizar la carpeta."
    exit 1
fi

# Construir la ruta automática siempre en ~/Música/artista/disco
CARPETA_DESTINO="$HOME/Música/${ARTISTA_INPUT}/${DISCO_INPUT}"

# Crear la estructura de carpetas si no existe (~/Música/Artista/Disco)
mkdir -p "$CARPETA_DESTINO"

echo "🎵 Descargando música de: $PLAYLIST_URL"
echo "📁 Guardando en carpeta: $CARPETA_DESTINO"

# Ejecutar descarga aplicando la ruta dinámica y forzando la metadata ingresada
yt-dlp \
  -f bestaudio \
  --extract-audio \
  --audio-format mp3 \
  --audio-quality 0 \
  -P "$CARPETA_DESTINO" \
  -o "%(title)s.%(ext)s" \
  --embed-metadata \
  --parse-metadata "%(title)s:%(title)s" \
  --metadata-from-title "%(title)s" \
  --ppa "ExtractAudio:-metadata artist='$ARTISTA_INPUT' -metadata album='$DISCO_INPUT' -metadata genre='$GENERO_INPUT'" \
  "$PLAYLIST_URL"

echo "✅ Descarga completada con éxito en: $CARPETA_DESTINO"
