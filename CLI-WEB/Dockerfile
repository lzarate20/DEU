
# Build stage
FROM node:14.18-alpine as build-stage
WORKDIR /app
COPY ./package*.json ./
RUN npm install
COPY ./ .
RUN npm run build

# Production stage
FROM node:14.18-alpine as production-stage
WORKDIR /app

# Copia los archivos construidos desde el build stage
COPY --from=build-stage /app/dist /app/dist

# Copia el resto de los archivos necesarios para el servidor Express
COPY ./package*.json ./
RUN npm install --only=production

# Copia el archivo del servidor Express
COPY ./server.js ./

# Exponer el puerto que usará el servidor Express
EXPOSE 8080

# Comando para ejecutar el servidor Express
CMD ["node", "server.js"]
