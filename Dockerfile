# Stage 1: Build file WAR
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Chạy ứng dụng trên Tomcat 10.1
FROM tomcat:10.1-jdk21

# 1. Cấu hình log Console ngay lúc build
RUN sed -i 's/handlers = .*/handlers = java.util.logging.ConsoleHandler/g' /usr/local/tomcat/conf/logging.properties && \
    sed -i 's/\.handlers = .*/.handlers = java.util.logging.ConsoleHandler/g' /usr/local/tomcat/conf/logging.properties

# 2. Xóa các ứng dụng mẫu mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# 3. Copy WAR vào ROOT
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

ENV PORT=8080
EXPOSE 8080

# 4. Tạo thư mục tạm tại /tmp và gán trực tiếp qua biến JVM lúc khởi động
CMD ["sh", "-c", "mkdir -p /tmp/work /tmp/temp && catalina.sh run"]