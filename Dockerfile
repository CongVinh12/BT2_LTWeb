# Stage 1: Build file WAR
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Khởi chạy trên Tomcat 10.1
FROM tomcat:10.1-jdk21

# 1. Chuyển log ra Console chống lỗi Read-only file system
RUN sed -i 's/^handlers = .*/handlers = java.util.logging.ConsoleHandler/' /usr/local/tomcat/conf/logging.properties && \
    sed -i 's/^\.handlers = .*/.handlers = java.util.logging.ConsoleHandler/' /usr/local/tomcat/conf/logging.properties

# 2. TẮT QUÉT TLD & JAR: Giúp Tomcat khởi động từ 90s xuống còn 2-3s (vượt qua Health Check ngay lập tức)
RUN sed -i 's/tomcat.util.scan.StandardJarScanFilter.jarsToSkip=/tomcat.util.scan.StandardJarScanFilter.jarsToSkip=*.jar,/g' /usr/local/tomcat/conf/catalina.properties

# 3. Tạo thư mục work/temp sang /tmp để tránh lỗi phân quyền
RUN rm -rf /usr/local/tomcat/work /usr/local/tomcat/temp && \
    mkdir -p /tmp/work /tmp/temp && \
    ln -s /tmp/work /usr/local/tomcat/work && \
    ln -s /tmp/temp /usr/local/tomcat/temp

# 4. Xóa ứng dụng mặc định và copy WAR mới
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

ENV PORT=8080
EXPOSE 8080

CMD ["catalina.sh", "run"]