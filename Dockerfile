FROM node:18-alpine

WORKDIR /app

# Instalar dependencias del sistema (ffmpeg, yt-dlp)
RUN apk add --no-cache ffmpeg python3 make g++ && \
    npm install -g yt-dlp

# Copiar archivos del servidor
COPY package.json ./
RUN npm install --production

COPY server.js ./
COPY .env.example ./

# Crear directorio de música
RUN mkdir -p music

# Puerto expuesto
ENV PORT=3000
ENV SERVER_MODE=render

EXPOSE 3000

CMD ["node", "server.js"]
