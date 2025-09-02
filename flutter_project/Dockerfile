# ---------- Etapa 1: Build de Flutter Web ----------
FROM debian:stable-slim AS build

ARG API_HOST
ENV API_HOST=${API_HOST}

# Instalar dependencias necesarias para Flutter
RUN apt-get update && apt-get install -y \
    curl unzip xz-utils git libglu1-mesa && \
    rm -rf /var/lib/apt/lists/*

# Descargar SDK de Flutter
WORKDIR /usr/src
RUN git clone https://github.com/flutter/flutter.git -b stable
ENV PATH="/usr/src/flutter/bin:/usr/src/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Precache (descarga binarios necesarios)
RUN flutter precache

# Copiar proyecto Flutter
WORKDIR /app
COPY . .

# Descargar dependencias y buildear en release
RUN flutter clean
RUN flutter pub get
RUN flutter build web --release

# ---------- Etapa 2: Servidor Express ----------
FROM node:20-alpine AS runtime

WORKDIR /app

# Copiar build de Flutter
COPY --from=build /app/build/web /app/build/web

# Copiar servidor Express y package.json
COPY server.js package.json package-lock.json ./

# Instalar dependencias
RUN npm install --production

EXPOSE 80

CMD ["node", "server.js"]

