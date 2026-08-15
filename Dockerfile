# Build stage
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# सर्व फाइल्स कॉपी करा
COPY . .

# pom.xml नक्की शोधून बिल्ड करा
RUN if [ -f "./pom.xml" ]; then \
      mvn clean package -DskipTests; \
    elif [ -f "./demo/pom.xml" ]; then \
      mvn -f ./demo/pom.xml clean package -DskipTests; \
    elif [ -f "./demo/demo/pom.xml" ]; then \
      mvn -f ./demo/demo/pom.xml clean package -DskipTests; \
    fi && \
    JAR_FILE=$(find . -name "*.jar" | grep -v "original" | head -n 1) && \
    cp "$JAR_FILE" /app/app.jar

# Run stage
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/app.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]