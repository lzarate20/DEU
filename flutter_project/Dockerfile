# ---------- Etapa 1: Build de Flutter Web ----------
FROM debian:stable-slim AS build

ARG CODESPACE_NAME
ENV API_HOST=${CODESPACE_NAME:+https://${CODESPACE_NAME}-8080.app.github.dev}
ENV API_HOST=${API_HOST:-http://localhost:8080}

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
RUN flutter pub get
RUN flutter build web --release --dart-define=API_HOST=$API_HOST

# ---------- Etapa 2: Servidor Nginx ----------
FROM nginx:alpine AS runtime

# Copiar build resultante al root de Nginx
COPY --from=build /app/build/web /usr/share/nginx/html

# Copiar config custom de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Configuración custom de Nginx (opcional)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]