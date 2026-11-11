# Stage 1: Build WAR bằng Maven và JDK 21
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Deploy lên Tomcat 10.1
FROM tomcat:10.1-jdk21

# 1. Chuyển log sang Console
RUN sed -i 's/^handlers = .*/handlers = java.util.logging.ConsoleHandler/' /usr/local/tomcat/conf/logging.properties && \
    sed -i 's/^\.handlers = .*/.handlers = java.util.logging.ConsoleHandler/' /usr/local/tomcat/conf/logging.properties

# 2. Cấu hình server.xml nhận port động và tắt shutdown port
RUN sed -i 's/port="8080"/port="${port.http:8080}"/' /usr/local/tomcat/conf/server.xml && \
    sed -i 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml

# 3. Chuyển workDir sang /tmp/work để tránh lỗi Read-only file system
RUN sed -i 's|<Context>|<Context workDir="/tmp/work">|' /usr/local/tomcat/conf/context.xml

# 4. Dọn dẹp và copy file WAR vào thư mục ROOT
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

ENV PORT=8080
EXPOSE 8080

# 5. Khởi chạy với cấu hình tối ưu bộ nhớ RAM cho container nhỏ
CMD ["sh", "-c", "mkdir -p /tmp/work /tmp/temp && export CATALINA_TMPDIR=/tmp/temp && export CATALINA_OPTS=\"-Dport.http=${PORT} -Djava.io.tmpdir=/tmp/temp -XX:+UseSerialGC -Xmx200m -Xss512k\" && catalina.sh run"]