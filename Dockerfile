# Use an official Tomcat runtime as a parent image
FROM tomcat:9.0-jdk11

# Set the working directory to the Tomcat webapps directory
WORKDIR $CATALINA_HOME/webapps

# Copy the WAR file into the webapps directory
COPY target/Doctor-Patient-Portal-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/Doctor-Patient-Portal-0.0.1-SNAPSHOT.war

# Optional: If your WAR file has a specific name, you can rename it to "ROOT.war" for the default context
# RUN mv Doctor-Patient-Portal-0.0.1-SNAPSHOT.war ROOT.war

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat when the container launches
CMD ["catalina.sh", "run"]
