# Build stage
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .

# pom.xml शोधून थेट बिल्ड करणे
RUN if [ -f "pom.xml" ]; then \
      mvn clean package -DskipTests; \
    elif [ -f "demo/pom.xml" ]; then \
      cd demo && mvn clean package -DskipTests && cd ..; \
    elif [ -f "demo/demo/pom.xml" ]; then \
      cd demo/demo && mvn clean package -DskipTests && cd ../..; \
    fi

# Run stage
FROM eclipse-temurin:17-jre
WORKDIR /app

# target फोल्डरमधील तयार झालेली JAR कॉपी करणे
COPY --from=build /app/**/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]