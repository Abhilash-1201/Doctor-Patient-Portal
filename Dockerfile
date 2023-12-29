# Use an official Tomcat runtime as a parent image
FROM tomcat:9

# Remove the default ROOT application (optional)
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy your application WAR file into the Tomcat webapps directory
COPY target/Doctor-Patient-Portal-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/Doctor-Patient-Portal-0.0.1-SNAPSHOT.war
# Optional: If your WAR file has a specific name, you can rename it to "ROOT.war" for the default context

# Expose the default Tomcat port
EXPOSE 8085

# Start Tomcat when the container runs
CMD ["catalina.sh", "run"]




