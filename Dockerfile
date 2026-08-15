# Build stage
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .

# Maven द्वारे बिल्ड करून JAR थेट /app/app.jar वर कॉपी करणे
RUN if [ -f "pom.xml" ]; then \
      mvn clean package -DskipTests && cp target/*.jar /app/app.jar; \
    elif [ -f "demo/pom.xml" ]; then \
      cd demo && mvn clean package -DskipTests && cp target/*.jar /app/app.jar; \
    elif [ -f "demo/demo/pom.xml" ]; then \
      cd demo/demo && mvn clean package -DskipTests && cp target/*.jar /app/app.jar; \
    fi

# Run stage
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/app.jar /app/app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]