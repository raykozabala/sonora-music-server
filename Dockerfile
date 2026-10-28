FROM node:18-alpine

WORKDIR /app

# Instalar ffmpeg, python3, pip y yt-dlp para extracción y conversión de audio
RUN apk add --no-cache ffmpeg python3 py3-pip && \
    (pip install --no-cache-dir -U yt-dlp --break-system-packages 2>/dev/null || pip install --no-cache-dir -U yt-dlp)

# Copiar dependencias del servidor
COPY package.json ./
RUN npm install --production

# Copiar código del servidor y frontend web
COPY server.js ./
COPY public ./public

# Crear directorios para datos y música
RUN mkdir -p music data

# Variables de entorno
ENV PORT=3000

EXPOSE 3000

CMD ["node", "server.js"]
