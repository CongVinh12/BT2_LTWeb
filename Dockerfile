FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM tomcat:10.1-jdk21

# 1. Tắt ghi log ra file cục bộ để chống lỗi "Read-only file system" trên cloud
RUN sed -i 's/handlers = .*/handlers = java.util.logging.ConsoleHandler/g' /usr/local/tomcat/conf/logging.properties && \
    sed -i 's/\.handlers = .*/.handlers = java.util.logging.ConsoleHandler/g' /usr/local/tomcat/conf/logging.properties

# 2. Dọn sạch webapps mặc định và tắt shutdown port
RUN rm -rf /usr/local/tomcat/webapps/*
RUN sed -i 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml

# 3. Dùng *.war thay vì ROOT.war để copy đúng file dù finalName là gì
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
ENV PORT=8080
CMD ["catalina.sh", "run"]