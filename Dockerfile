FROM --platform=linux/amd64 amazoncorretto:11-alpine3.14

RUN mkdir /myapp
COPY /user-microservice/target/*.jar myapp

# Install Bash
RUN apk update && apk add bash

# Add a group and user 
RUN addgroup -g 1000 user \
    && adduser -u 1000 -G user -s user -D user

# Set the user 
USER user

# ENVIRONMENT VARIABLES
ENV APP_PORT ""
ENV DB_USERNAME ""
ENV DB_PASSWORD ""
ENV DB_HOST ""
ENV DB_PORT ""
ENV DB_NAME ""
ENV ENCRYPT_SECRET_KEY ""
ENV JWT_SECRET_KEY ""

EXPOSE ${APP_PORT}

WORKDIR /myapp
CMD java -jar bank-microservice-0.1.0.jar
