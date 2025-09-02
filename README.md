# DEU

## Arranque de aplicación de manera local (en una maquina con docker instalado)

1. En una terminal de comandos dirigirse a la ubicación donde esta docker-compose.yml
   - Ejemplo (suponiendo que estamos en home y la app esta en el escritorio):
   ```
    cd .\Desktop\DEU
   ```
2. Ejecute el siguiente comando:
   ```
   docker-compose up --build --force-recreate
   ```
   
3. Este comando levanta 2 contenedores: 
   - front de flutter en localhost puerto 80
   - back en kotlin en localhost puerto 8080

4. Para acceder de puede usar uno de los usuarios que se crean al levantar la app: 
   - Entrenador: john.trainer@example.com contraseña: 1234
   - Jugador: jane.trainee@example.com contraseña: 1234