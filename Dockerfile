FROM node:18-alpine

WORKDIR /app

# Copiar archivos del servidor
COPY package.json ./
RUN npm install --production

COPY server.js ./

# Crear directorio de música (para descargas futuras)
RUN mkdir -p music

# Puerto expuesto
ENV PORT=3000
ENV SERVER_MODE=render

EXPOSE 3000

CMD ["node", "server.js"]
