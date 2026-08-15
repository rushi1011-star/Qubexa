# Build stage
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .

# demo/demo मधील pom.xml शोधून बिल्ड करणे
RUN POM=$(find /app -name "pom.xml" | head -n 1) && \
    echo "Found POM at: $POM" && \
    mvn -f "$POM" clean package -DskipTests && \
    JAR=$(find /app -name "*.jar" -path "*/target/*" ! -name "*original*" | head -n 1) && \
    cp "$JAR" /app/app.jar

# Run stage
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/app.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]