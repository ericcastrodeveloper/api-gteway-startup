FROM openjdk:11 as build
WORKDIR /workspace/v1/api-gateway

COPY /api-gateway/mvnw .
COPY /api-gateway/.mvn .mvn
COPY /api-gateway/pom.xml .
COPY /api-gateway/src src

RUN chmod +x ./mvnw
RUN ./mvnw install -DskipTests
RUN mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)

FROM openjdk:11
VOLUME /tmp
ARG DEPENDENCY=/workspace/v1/api-gateway/target/dependency
COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app
EXPOSE 8080
ENTRYPOINT ["java","-cp","app:app/lib/*","br.com.apigateway.ApiGatewayApplication"]

