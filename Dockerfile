# Use an official Tomcat runtime as a parent image
FROM tomcat:9

# Copy the WAR file into the webapps directory
COPY /var/lib/jenkins/workspace/Doctor-Patient-Portal/target/Doctor-Patient-Portal-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/Doctor-Patient-Portal-0.0.1-SNAPSHOT.war

# Optional: If your WAR file has a specific name, you can rename it to "ROOT.war" for the default context
# RUN mv Doctor-Patient-Portal-0.0.1-SNAPSHOT.war ROOT.war

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat when the container launches
CMD ["catalina.sh", "run"]
