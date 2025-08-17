FROM ubuntu:22.04 AS builder

RUN apt-get update && \
    apt-get install -y openjdk-21-jdk maven && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copiamos el resto del código fuente
COPY src ./src

# Compilamos la app
RUN mvn clean package -DskipTests

FROM ubuntu:22.04 AS runtime

RUN apt-get update && \
    apt-get install -y openjdk-21-jdk && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
