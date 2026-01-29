mvn clean package && \
mkdir target/uploads && \
cp images/* target/uploads/ &&\
mvn spring-boot:run