# Use OpenJDK base image
FROM openjdk:8u151-jdk-alpine3.7

# Set environment variable for app home
ENV APP_HOME /usr/src/app
WORKDIR $APP_HOME

# Copy the built JAR file into the container
COPY target/secretsanta-0.0.1-SNAPSHOT.jar $APP_HOME/app.jar

# Expose the application port (if applicable)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "/usr/src/app/app.jar"]
