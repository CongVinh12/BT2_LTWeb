
# Stage 1: Build WAR bằng Maven và JDK 21
FROM maven:3.9.6-eclipse-temurin-21 AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

# Stage 2: Deploy lên Tomcat 10.1
FROM tomcat:10.1-jdk21

# Chuyển log sang Console
RUN sed -i 's/^handlers = .*/handlers = java.util.logging.ConsoleHandler/' /usr/local/tomcat/conf/logging.properties && \
    sed -i 's/^\.handlers = .*/.handlers = java.util.logging.ConsoleHandler/' /usr/local/tomcat/conf/logging.properties

# Nhận cổng từ System Property
RUN sed -i 's/port="8080"/port="${port.http:8080}"/' /usr/local/tomcat/conf/server.xml && \
    sed -i 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml

# Chuyển thư mục tạm sang /tmp
RUN rm -rf /usr/local/tomcat/work /usr/local/tomcat/temp && \
    mkdir -p /tmp/work /tmp/temp && \
    ln -s /tmp/work /usr/local/tomcat/work && \
    ln -s /tmp/temp /usr/local/tomcat/temp

# Xóa ứng dụng mặc định
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Port mặc định
ENV PORT=8080

EXPOSE 8080

# Khởi chạy Tomcat với PORT của Render
CMD ["sh", "-c", "export CATALINA_OPTS=\"-Dport.http=${PORT}\" && catalina.sh run"]
