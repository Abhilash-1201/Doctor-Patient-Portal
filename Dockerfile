# Use an official Tomcat runtime as a base image
FROM tomcat:9

# Remove the default ROOT application (optional)
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy your application WAR file into the Tomcat webapps directory
# Create a directory to store the WAR file
RUN mkdir /app

# Copy your application WAR file into the Tomcat webapps directory
COPY Doctor-Patient-Portal-0.0.1-SNAPSHOT.war /app/ROOT.war

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat when the container runs
CMD ["catalina.sh", "run"]