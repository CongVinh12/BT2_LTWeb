# Stage 1: Build file WAR
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Triển khai lên Tomcat 10.1
FROM tomcat:10.1-jdk21

# 1. Cấu hình log xuất ra Console (chạy lúc build nên có quyền ghi)
RUN sed -i 's/handlers = .*/handlers = java.util.logging.ConsoleHandler/g' /usr/local/tomcat/conf/logging.properties && \
    sed -i 's/\.handlers = .*/.handlers = java.util.logging.ConsoleHandler/g' /usr/local/tomcat/conf/logging.properties

# 2. Cấu hình connector nhận System Property "port.http" (mặc định 8080 nếu không truyền)
# và tắt shutdown port
RUN sed -i 's/port="8080"/port="${port.http:8080}"/' /usr/local/tomcat/conf/server.xml && \
    sed -i 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml

# 3. Tạo thư mục làm việc và trỏ work/temp sang /tmp (vùng nhớ tạm cho phép ghi)
RUN rm -rf /usr/local/tomcat/work /usr/local/tomcat/temp && \
    mkdir -p /tmp/work /tmp/temp && \
    ln -s /tmp/work /usr/local/tomcat/work && \
    ln -s /tmp/temp /usr/local/tomcat/temp

# 4. Dọn dẹp ứng dụng cũ và copy file war mới vào ROOT.war
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

ENV PORT=8080
EXPOSE 8080

# 5. Khởi chạy Tomcat: truyền PORT vào -Dport.http mà KHÔNG cần lệnh sed
CMD ["sh", "-c", "export CATALINA_OPTS=\"-Dport.http=${PORT}\" && catalina.sh run"]