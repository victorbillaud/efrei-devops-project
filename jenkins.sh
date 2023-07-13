sudo apt-get update
sudo apt-get install -y openjdk-11-jre
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install -y jenkins

sudo systemctl enable jenkins
sudo systemctl start jenkins

# # Wait for Jenkins to start
# sleep 30

# # Install the plugins
# curl -X POST -d '<jenkins><install plugin="docker-plugin@latest" /></jenkins>' \
#   -H 'Content-Type: text/xml' \
#   http://localhost:8080/pluginManager/installNecessaryPlugins

# # Restart Jenkins
# curl -X POST http://localhost:8080/safeRestart

# # Wait for Jenkins to restart
# sleep 30

# # Copy the config.xml file to the Jenkins home directory
# cp ./shared/config.xml /var/lib/jenkins/
# cp ./shared/credentials.xml /var/lib/jenkins/

# # Restart Jenkins again to apply the new configuration
# curl -X POST http://localhost:8080/safeRestart

# sleep 30

# # Create the Pipeline job
# curl -X POST -H "Content-Type: application/xml" -d @/shared/portfolio.xml \
#   http://localhost:8080/createItem?name=portfolio

# # Trigger a build of the Pipeline job
# curl -X POST http://localhost:8080/job/portfolio/build

# # Install the plugins
# curl -X POST -d '<jenkins><install plugin="docker-plugin@latest" /></jenkins>' \
#   -H 'Content-Type: text/xml' \
#   --user 'admin:password' \
#   http://localhost:8080/pluginManager/installNecessaryPlugins

