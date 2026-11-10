# Stage 1: Build file WAR
FROM maven:3.9-eclipse-temurin-21 AS build_stage
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests


FROM tomcat:9.0-jdk21-temurin
WORKDIR /usr/local/tomcat/webapps/

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=build_stage /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

 sed -i '/Valve className="org.apache.catalina.valves.AccessLogValve"/,/ \/>/d' /usr/local/tomcat/conf/server.xml && \
    sed -i 's/handlers = .*/handlers = java.util.logging.ConsoleHandler/g' /usr/local/tomcat/conf/logging.properties

ENV CATALINA_TMPDIR=/tmp
ENV CATALINA_OPTS="-Djava.io.tmpdir=/tmp"

EXPOSE 8080

CMD ["sh", "-c", "sed -i 's/port=\"8080\"/port=\"'\"${PORT:-8080}\"'\"/g' /usr/local/tomcat/conf/server.xml && catalina.sh run"]