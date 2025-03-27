
FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app

# 1) 빌드 결과 JAR 복사 (Gradle 빌드 후)
COPY build/libs/tmi-news-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
