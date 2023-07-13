#!/bin/bash

# Get the username and API token from the command-line arguments
JENKINS_USERNAME=$1
JENKINS_API_TOKEN=$2

echo "Jenkins username: $JENKINS_USERNAME"

echo "Get the crumbs"
# Get the crumb
CRUMB=$(curl -s 'http://localhost:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)' \
  --user "$JENKINS_USERNAME:$JENKINS_API_TOKEN")

if [ -z "$CRUMB" ]; then
  echo "Failed to get crumb"
  exit 1
fi

echo $CRUMB

echo "Check if Docker plugin is installed"
# Check if Docker plugin is installed
DOCKER_PLUGIN_INSTALLED=$(curl -s 'http://localhost:8080/pluginManager/api/json?depth=1' \
  --user "$JENKINS_USERNAME:$JENKINS_API_TOKEN" | \
  grep -o '"shortName":"docker-plugin","active":true')

if [ -z "$DOCKER_PLUGIN_INSTALLED" ]; then
  echo "Installing docker..."
  # Install the plugins
  INSTALL_RESPONSE=$(curl -s -X POST -d '<jenkins><install plugin="docker-plugin@latest" /></jenkins>' \
    -H 'Content-Type: text/xml' \
    -H "$CRUMB" \
    --user "$JENKINS_USERNAME:$JENKINS_API_TOKEN" \
    http://localhost:8080/pluginManager/installNecessaryPlugins)

  if [[ $INSTALL_RESPONSE == *"Error"* ]]; then
    echo "Failed to install Docker plugin"
    exit 1
  fi

  sleep 20
else
  echo "Docker plugin is already installed"
fi

echo "Restart Jenkins"
# Restart Jenkins
RESTART_RESPONSE=$(curl -s -X POST http://localhost:8080/safeRestart \
  --user "$JENKINS_USERNAME:$JENKINS_API_TOKEN")

if [[ $RESTART_RESPONSE == *"Error"* ]]; then
  echo "Failed to restart Jenkins"
  exit 1
fi

# Wait for Jenkins to restart
sleep 30

echo "Copy config files"
# Copy the config.xml file to the Jenkins home directory
sudo cp ./config.xml /var/lib/jenkins/
sudo cp ./credentials.xml /var/lib/jenkins/

echo "Restart Jenkins again"
# Restart Jenkins again to apply the new configuration
RESTART_RESPONSE=$(curl -s -X POST http://localhost:8080/safeRestart \
  --user "$JENKINS_USERNAME:$JENKINS_API_TOKEN")

if [[ $RESTART_RESPONSE == *"Error"* ]]; then
  echo "Failed to restart Jenkins"
  exit 1
fi

# Wait for Jenkins to restart again
sleep 30

echo "Creating user"
# Create the user

CREATE_USER_RESPONSE=$(curl -s -X POST -d "script=import hudson.security.HudsonPrivateSecurityRealm;Jenkins.instance.securityRealm.createAccount('devops', 'devops')" \
  --user "$JENKINS_USERNAME:$JENKINS_API_TOKEN" \
  http://localhost:8080/scriptText)

if [[ $CREATE_USER_RESPONSE == *"Error"* ]]; then
  echo "Failed to create user"
  exit 1
fi

echo "Create the Pipeline job"
# Create the Pipeline job
CREATE_JOB_RESPONSE=$(curl -s -X POST -H "Content-Type: application/xml" -d @portfolio.xml \
  --user "$JENKINS_USERNAME:$JENKINS_API_TOKEN" \
  http://localhost:8080/createItem?name=portfolio)

if [[ $CREATE_JOB_RESPONSE == *"Error"* ]]; then
  echo "Failed to create Pipeline job"
  exit 1
fi

# Trigger a build of the Pipeline job
TRIGGER_BUILD_RESPONSE=$(curl -s -X POST http://localhost:8080/job/portfolio/build \
  --user "$JENKINS_USERNAME:$JENKINS_API_TOKEN")

if [[ $TRIGGER_BUILD_RESPONSE == *"Error"* ]]; then
  echo "Failed to trigger build of Pipeline job"
  exit 1
fi

echo "Done"
