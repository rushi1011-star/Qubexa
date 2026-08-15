# Build stage
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .

# pom.xml फाईल जिथे असेल तिथून शोधून प्रोजेक्ट बिल्ड करणे
RUN POM_PATH=$(find . -name "pom.xml" | head -n 1) && \
    echo "Using POM from: $POM_PATH" && \
    mvn -f "$POM_PATH" clean package -DskipTests && \
    JAR_PATH=$(find . -name "*.jar" | grep -v "original" | head -n 1) && \
    cp "$JAR_PATH" /app/app.jar

# Run stage
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/app.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]