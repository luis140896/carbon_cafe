# Multi-stage Dockerfile for Spring Boot backend (Render-compatible)

# ===== Build stage =====
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -B clean package -DskipTests

# ===== Runtime stage =====
FROM eclipse-temurin:17-jre
WORKDIR /app
# Cambia el nombre del jar si modificas artifactId/version en pom.xml
COPY --from=build /app/target/pos-1.0.0.jar app.jar

# Render expone un puerto dinámico mediante la variable PORT
ENV PORT=8080
EXPOSE 8080

ENTRYPOINT ["java","-jar","/app/app.jar","--spring.profiles.active=${SPRING_PROFILES_ACTIVE:-prod}","--server.port=${PORT}"]
