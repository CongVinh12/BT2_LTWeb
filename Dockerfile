FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM tomcat:10.1-jdk21

# 1. Chuyển log ra Console chống lỗi Read-only file system
RUN sed -i 's/handlers = .*/handlers = java.util.logging.ConsoleHandler/g' /usr/local/tomcat/conf/logging.properties && \
    sed -i 's/\.handlers = .*/.handlers = java.util.logging.ConsoleHandler/g' /usr/local/tomcat/conf/logging.properties

# 2. Cấp quyền ghi cho work và temp
RUN mkdir -p /usr/local/tomcat/work/Catalina/localhost/ROOT && \
    mkdir -p /usr/local/tomcat/temp && \
    chmod -R 777 /usr/local/tomcat/work /usr/local/tomcat/temp

# 3. Dọn dẹp ứng dụng mặc định và tắt shutdown port
RUN rm -rf /usr/local/tomcat/webapps/*
RUN sed -i 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml

# 4. Copy file WAR vào thư mục ROOT
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# 5. Cấu hình Tomcat nhận biến PORT từ Hostless
ENV PORT=8080
EXPOSE ${PORT}

# Khi container chạy, thay thế port 8080 trong server.xml bằng giá trị $PORT thực tế do host cấp
CMD sed -i "s/port=\"8080\"/port=\"${PORT}\"/g" /usr/local/tomcat/conf/server.xml && catalina.sh run