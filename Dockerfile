FROM maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

FROM tomcat:9.0-jdk21-temurin

COPY --from=builder /app/target/untitled5.war /usr/local/tomcat/webapps/ROOT.war

RUN mkdir -p /usr/local/tomcat/work

EXPOSE 8080

CMD ["catalina.sh", "run"]
