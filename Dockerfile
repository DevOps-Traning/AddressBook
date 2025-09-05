# Use the official Tomcat image as a base
FROM tomcat:latest

# Remove the default ROOT webapp (optional, unless you want to deploy at root)
RUN rm -fr /usr/local/tomcat/webapps/ROOT

# Copy your WAR file into the Tomcat webapps directory
COPY target/addressbook.war /usr/local/tomcat/webapps/addressbook.war

# Expose Tomcat's port
EXPOSE 8080

# Command to run Tomcat
CMD ["catalina.sh", "run"]
