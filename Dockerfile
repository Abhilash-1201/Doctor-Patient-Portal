# Use an official Tomcat runtime as a base image
FROM tomcat:9

# Remove the default ROOT application (optional)
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy your application WAR file into the Tomcat webapps directory
COPY /var/lib/jenkins/workspace/Doctor-Patient-Portal/target/Doctor-Patient-Portal.war /usr/local/tomcat/webapps/Doctor-Patient-Portal.war

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat when the container runs
CMD ["catalina.sh", "run"]