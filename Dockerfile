# Build stage
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .

# सर्व सब-फोल्डर्समधून pom.xml शोधून बिल्ड करणे व JAR कॉपी करणे
RUN set -e; \
    POM=$(find /app -name "pom.xml" | head -n 1); \
    echo "Building using: $POM"; \
    mvn -f "$POM" clean package -DskipTests; \
    JAR=$(find /app -type f -name "*.jar" -path "*/target/*" ! -name "*original*" | head -n 1); \
    echo "Found executable JAR: $JAR"; \
    cp "$JAR" /app/server.jar

# Run stage
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/server.jar /app/server.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/server.jar"]