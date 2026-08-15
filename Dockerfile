# Build stage
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .

# Maven द्वारे बिल्ड करणे आणि target फोल्डरमधील Spring Boot JAR शोधणे
RUN if [ -f "./pom.xml" ]; then \
      mvn clean package -DskipTests; \
    elif [ -f "./demo/pom.xml" ]; then \
      mvn -f ./demo/pom.xml clean package -DskipTests; \
    elif [ -f "./demo/demo/pom.xml" ]; then \
      mvn -f ./demo/demo/pom.xml clean package -DskipTests; \
    fi && \
    JAR_FILE=$(find . -path "*/target/*.jar" ! -name "*.original" ! -name "*-sources.jar" | head -n 1) && \
    echo "Found executable JAR: $JAR_FILE" && \
    cp "$JAR_FILE" /app/app.jar

# Run stage
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/app.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]