# 🎵 Sonora Music Server v7.5

Servidor backend **triple-mode** para Sonora Music App. Funciona en tu **computadora local (PC/Mac)**, **Render.com** y **Northflank**. Permite streaming de audio, búsqueda en YouTube/SoundCloud, y descarga/conversión de YouTube a MP3.

---

## 📋 Estructura del Proyecto

```
sonora-music/
├── server/
│   ├── server.js              # Servidor Express principal
│   ├── package.json           # Dependencias Node.js
│   ├── .env.example           # Ejemplo de variables de entorno
│   ├── start-local.bat        # Iniciar en Windows
│   ├── start-local.sh         # Iniciar en Mac/Linux
│   ├── Dockerfile             # Para desplegar en Render
│   ├── musica/                # Carpeta donde se guardan los MP3 descargados (se crea automáticamente)
│   └── sonora.db              # Base de datos SQLite
├── render.yaml                # Configuración de despliegue en Render
├── northflank.yaml            # Configuración de despliegue en Northflank
└── android-build/             # Código de la app móvil (APK)
```

---

## 🖥️ Opción 1: Ejecutar en tu Computadora Local (PC/Mac)

### Requisitos previos

1. **Node.js** - [Descargar e instalar](https://nodejs.org/)
2. **ffmpeg** - Para convertir YouTube a MP3
   - **Windows (winget):** `winget install ffmpeg`
   - **macOS:** `brew install ffmpeg`
   - **Ubuntu/Debian:** `sudo apt install ffmpeg`
3. **yt-dlp** - Para descargar de YouTube
   - **Windows (winget):** `winget install yt-dlp`
   - **macOS:** `brew install yt-dlp` o `npm install -g yt-dlp`
   - **Ubuntu:** `sudo apt install yt-dlp` o `pip install yt-dlp`

### Pasos

#### Windows
1. Haz doble clic en `server/start-local.bat`
2. O abre PowerShell/CMD en la carpeta `server/` y ejecuta:
   ```powershell
   .\start-local.bat
   ```

#### Mac / Linux
1. Abre Terminal en la carpeta `server/`
2. Ejecuta:
   ```bash
   chmod +x start-local.sh
   ./start-local.sh
   ```

### Verificar que funciona

Una vez iniciado, abre tu navegador y visita:
- **Salud del servidor:** http://localhost:3000/api/health
- **Lista de descargas:** http://localhost:3000/api/downloads

Deberías ver algo como:
```json
{ "status": "ok", "server": "local", "uptime": 120, "version": "4.0.0" }
```

### Conectar la app móvil

En la app Sonora Music en tu Android:
1. Ve a **Ajustes > Conexión al Servidor**
2. Activa **Servidor Local**
3. En la URL escribe tu IP local (ej: `http://192.168.1.132:3000`)
   - Para encontrar tu IP: en Windows `ipconfig`, en Mac/Linux `ifconfig` o `hostname -I`
4. Haz clic en **"Probar conexión"**
5. Cuando esté verde, la app usará tu servidor local

---

## ☁️ Opción 2: Desplegar en Render.com

Render permite tener el servidor en la nube para acceder desde cualquier lugar.

### Pasos

1. Sube el código a un repositorio GitHub
2. Ve a [Render.com](https://render.com) y crea una cuenta gratuita
3. Haz clic en **"New +" > "Web Service"**
4. Conecta tu repositorio de GitHub
5. Configura:
   - **Runtime:** Docker
   - **Dockerfile:** `server/Dockerfile`
   - **Root Directory:** `./server`
   - **Environment Variables:**
     - `PORT` = `3000`
     - `SERVER_MODE` = `render`
     - `SERVER_URL` = `https://tu-app.onrender.com`
6. Haz clic en **"Create Web Service"**

### Usando render.yaml

Si tienes el archivo `render.yaml` en la raíz del proyecto, Render lo detectará automáticamente:

```yaml
services:
  - type: web
    name: sonora-music-server
    env: docker
    dockerfile: ./Dockerfile
    rootDir: ./server
    envVars:
      - key: PORT
        value: 3000
      - key: SERVER_MODE
        value: render
```

### Verificar en Render

Visita: `https://tu-app.onrender.com/api/health`

---

## ☁️ Opción 3: Desplegar en Northflank

Northflank permite desplegar el servidor con mayor control y escalabilidad.

### Configuración con Token API

El token API proporcionado conecta todo el servidor con Northflank de forma segura. El token JWT contiene los datos del usuario, equipo y rol necesarios para la autenticación.

### Configuración

Crea un archivo `northflank.yaml` en la raíz del proyecto:

```yaml
services:
  - type: web
    name: sonora-music-server
    env: docker
    dockerfile: ./Dockerfile
    rootDir: ./server
    envVars:
      - key: PORT
        value: 3000
      - key: SERVER_MODE
        value: northflank
      - key: SERVER_URL
        value: https://api.northflank.com
      - key: NORTHFLANK_URL
        value: https://api.northflank.com
      - key: API_TOKEN
        value: nf-eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiYjk5YzY1ZWYtYjQwYy00NTNmLWE2ODUtYzlkN2QyY2QzMDg5IiwiZW50aXR5SWQiOiI2YWUyM2YxOTMwNmFiOTYxN2Q3N2IwNmMiLCJlbnRpdHlUeXBlIjoidGVhbSIsInRva2VuSWQiOiI2YWUyNDUxMjA5NDBlOTA3ZDc1MGI0OTEiLCJ0b2tlbkludGVybmFsSWQiOiJzb25vcmEtZGVwbG95Iiwicm9sZUlkIjoiNmFlMjNmMTkzMDZhYjk2MTdkNzbiMDZkIiwicm9sZUVudGl0eUlkIjoiNmFlMjNmMTkzMDZhYjk2MTdkNzbiMDZjIiwicm9sZUVudGl0eVR5cGUiOiJ0ZWFtIiwicm9sZUludGVybmFsSWQiOiJvd25lciIsInR5cGUiOiJyYmFjIiwiaWF0IjoxNzkzMjEzNzE0fQ.BC3qvwrrLT3eySEIzCT81KuOwQIeoKU47M1nKHGrxmc
```

### Variables de Entorno para Northflank

- `SERVER_MODE` = `northflank`
- `SERVER_URL` = URL de tu servicio en Northflank
- `NORTHFLANK_URL` = `https://api.northflank.com`
- `API_TOKEN` = Token JWT para autenticación con Northflank

### Verificar en Northflank

Visita: `https://tu-app.onnorthflank.com/api/health`

La respuesta incluirá:
```json
{
  "status": "ok",
  "server": "northflank",
  "mode": "northflank",
  "apiToken": "nf-...",
  "connected": true,
  "uptime": 120,
  "version": "7.12.0"
}
```

---

## 📱 Funcionalidades del Servidor

| Endpoint | Método | Descripción |
|----------|--------|-------------|
| `/api/health` | GET | Estado del servidor (local/render/northflank) |
| `/api/tracks` | GET | Lista todas las canciones |
| `/api/tracks/search?q=` | GET | Buscar canciones por título/artista |
| `/api/tracks/:id` | GET | Obtener canción por ID |
| `/api/stream/:id` | GET | Reproducir audio de una canción |
| `/api/stream/external?url=` | GET | Reproducir audio de YouTube/SoundCloud en vivo |
| `/api/search/external?q=` | GET | Buscar en YouTube y SoundCloud |
| `/api/recommendations?artist=&title=` | GET | Canciones recomendadas (autoplay) |
| `/api/download/youtube` | POST | **Descargar YouTube → MP3** (guardar en servidor) |
| `/api/download/file/:filename` | GET | Descargar un MP3 ya convertido |
| `/api/downloads` | GET | Lista de MP3 descargados en el servidor |
| `/api/downloads/:filename` | DELETE | Eliminar un MP3 descargado |
| `/api/albums` | GET | Lista de álbumes |
| `/api/artists` | GET | Lista de artistas |
| `/api/playlists` | GET | Lista de playlists |
| `/api/users/register` | POST | Registrar usuario |
| `/api/users/login` | POST | Iniciar sesión |

---

## 📥 Descargar YouTube a MP3

La app móvil llama al endpoint `POST /api/download/youtube` con:
```json
{
  "url": "https://www.youtube.com/watch?v=XXXX",
  "title": "Nombre de la canción",
  "artist": "Nombre del artista"
}
```

El servidor:
1. Descarga el audio de YouTube con yt-dlp
2. Lo convierte a MP3 (320kbps) con ffmpeg
3. Lo guarda en la carpeta `server/musica/`
4. Devuelve una URL para descargar el archivo

Desde la app:
1. Busca una canción de YouTube
2. Dale al botón de descarga (⬇️)
3. La canción se descarga y guarda en tu dispositivo Android
4. Puedes reproducirla sin conexión desde **Biblioteca > Descargados**

---

## 🔧 Solución de Problemas

### El servidor no inicia
- Verifica que Node.js esté instalado: `node --version`
- Verifica que el puerto 3000 no esté en uso por otro programa
- Revisa que tengas permisos para crear la carpeta `musica/`

### YouTube no se descarga
- Verifica que ffmpeg esté instalado: `ffmpeg -version`
- Verifica que yt-dlp esté instalado: `yt-dlp --version`
- Revisa los logs del servidor para ver el error detallado

### La app no se conecta al servidor local
- Asegúrate de que tu PC y el Android estén en la misma WiFi
- Verifica tu IP local (Windows: `ipconfig`, Mac: `ifconfig \| grep inet`)
- Prueba la URL en el navegador del Android: `http://TU-IP:3000/api/health`
- En la app, activa "Servidor Local" e ingresa la IP correcta

### No se puede reproducir audio
- Si usas modo local y la canción no está descargada en el servidor, el servidor intentará hacer streaming en vivo desde YouTube (requiere conexión a internet)
- Si usas modo offline, solo se reproducirán canciones ya descargadas en el dispositivo

---

## 📦 Versiones

- **App:** v7.5 Ultimate
- **Servidor:** v4.0.0
- **Base de datos:** SQLite (sonora.db)
- **Streaming:** yt-dlp + ffmpeg

---

## 📞 Soporte

Si tienes problemas, revisa los logs de la consola del servidor para ver mensajes de error detallados.
