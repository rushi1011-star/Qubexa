# Build stage
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .

# Root किंवा subfolder मधील pom.xml शोधून बिल्ड करणे
RUN if [ -f "pom.xml" ]; then \
      mvn clean package -DskipTests; \
    elif [ -f "demo/pom.xml" ]; then \
      cd demo && mvn clean package -DskipTests && cp target/*.jar /app/app.jar; \
    elif [ -f "demo/demo/pom.xml" ]; then \
      cd demo/demo && mvn clean package -DskipTests && cp target/*.jar /app/app.jar; \
    else \
      POM=$(find . -name "pom.xml" | head -n 1) && \
      mvn -f "$POM" clean package -DskipTests && \
      JAR=$(find . -name "*.jar" -path "*/target/*" ! -name "*original*" | head -n 1) && \
      cp "$JAR" /app/app.jar; \
    fi && \
    if [ ! -f "/app/app.jar" ]; then \
      JAR=$(find . -name "*.jar" -path "*/target/*" ! -name "*original*" | head -n 1) && \
      cp "$JAR" /app/app.jar; \
    fi

# Run stage
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/app.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]