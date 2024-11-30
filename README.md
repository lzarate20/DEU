# DEU

## Arranque de aplicación de manera local (en una maquina con docker instalado)

1. En una terminal de comandos dirigirse a la ubicación donde esta docker-compose.yml
   - Ejemplo (suponiendo que estamos en home y la app esta en el escritorio):
   ```
    cd .\Desktop\DEU
   ```
2. Ejecute el siguiente comando:
   ```
   docker-compose up
   ```

## Arranque desde [Docker Playground](https://labs.play-with-docker.com)

1. Iniciar sesión
2. Crear nueva instancia ("+ ADD NEW INSTANCE")
3. En la nueva instancia ingrese el comando:
   ```
    touch docker-compose.yml
   ```
4. Copiar el siguiente texto:

   ```
      version: '3.3'

      services:
         db:
            image: gastonnicora/deu_db
            ports:
               - "3306:3306"
            restart: always
            environment:
               MYSQL_ROOT_PASSWORD: root
               MYSQL_USER: tpdeu
               MYSQL_PASSWORD: tpdeu
               MYSQL_DATABASE: tpdeu  
         api:
            image: gastonnicora/deu_api
            restart: always
            depends_on:
               - db
            links:
               - db
            ports:
               - "4000:4000"
         cli-web:
            image: gastonnicora/deu_web
            restart: always
            depends_on:
               - api
            links:
               - api
            ports:
               - "80:8080"
         phpmyadmin:
            image: phpmyadmin
            restart: always
            environment:
               PMA_HOST: db
               PMA_PORT: 3306
            ports:
               - 90:80


    ```

5. Presionar el botón "editor"
6. En la ventana emergente seleccionar el archivo "docker-compose.yml"
7. Pegar el texto anteriormente seleccionado, presionar el botón "SAVE" y cerrar ventana.
8. Ejecutar el siguiente código:
   ```
       docker-compose up
   ```
En el puerto 80 esta la aplicación Vue
En el puerto 3306 la base de datos
En el puerto 4000 esta el backend pero ademas en "/" estan listados todos los endpoind de la api
pueto 90 es phpmyadmin de la base de datos donde usuario y contraseña son tpdeu