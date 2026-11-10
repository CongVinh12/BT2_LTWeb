
FROM maven:3.9-eclipse-temurin-21 AS build_stage
WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

# Stage 2: Runtime với Tomcat 9
FROM tomcat:9.0-jdk21-temurin
WORKDIR /usr/local/tomcat/webapps/

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=build_stage /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

RUN mkdir -p /usr/local/tomcat/work/Catalina/localhost/ROOT && \
    chmod -R 777 /usr/local/tomcat/work

EXPOSE 8080


CMD ["sh", "-c", "sed -i 's/port=\"8080\"/port=\"'\"${PORT:-8080}\"'\"/g' /usr/local/tomcat/conf/server.xml && catalina.sh run"]