FROM openjdk:8-jdk-alpine
VOLUME /tmp
ADD target/kubeapp-0.0.1-SNAPSHOT.jar app.jar
ENV JAVA_OPTS=""
ENTRYPOINT exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar

HEALTHCHECK --interval=5s \
            --timeout=5s \
            CMD curl -f http://127.0.0.1:9081 || exit 1


# tell docker what port to expose
EXPOSE 9081
