# ---------------------------------------------------------------------------
# Sonora Music — Imagen de producción (Render / Northflank / Docker local)
# Incluye FFmpeg, yt-dlp y Deno. Deno es necesario porque yt-dlp lo usa para
# resolver los desafíos de YouTube (nsig / PO token); sin él la extracción
# falla con "Requested format is not available".
# ---------------------------------------------------------------------------
FROM node:20-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
      ffmpeg \
      python3 \
      curl \
      unzip \
      ca-certificates \
      build-essential \
    && curl -fsSL https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp \
    && chmod +x /usr/local/bin/yt-dlp \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://github.com/denoland/deno/releases/latest/download/deno-x86_64-unknown-linux-gnu.zip \
      -o /tmp/deno.zip \
    && unzip -o /tmp/deno.zip -d /usr/local/bin \
    && chmod +x /usr/local/bin/deno \
    && rm -f /tmp/deno.zip \
    && deno --version

# Evita escrituras fallidas en el home del contenedor
ENV DENO_DIR=/tmp/deno-cache
ENV HOME=/tmp

WORKDIR /app

COPY package*.json ./
RUN npm install --omit=dev

COPY server.js ./
COPY public ./public

RUN mkdir -p music data

ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=25s --retries=3 \
  CMD node -e "require('http').get('http://127.0.0.1:'+(process.env.PORT||3000)+'/api/health',r=>process.exit(r.statusCode===200?0:1)).on('error',()=>process.exit(1))"

CMD ["node", "server.js"]
