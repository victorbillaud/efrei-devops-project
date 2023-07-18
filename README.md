# My Project

This project sets up a Jenkins instance and a Docker host using Vagrant.

## Prerequisites

Before you begin, make sure you have the following software installed on your computer:

- [Vagrant](https://www.vagrantup.com/downloads.html)

## Getting Started

Follow these steps to set up the project:

1. Open a terminal or command prompt and navigate to the directory where you cloned this repository.
2. Run `vagrant up` to start the two virtual machines (Jenkins and Docker).
3. Wait for the machines to finish booting up. This may take several minutes.
4. SSH into the Jenkins machine by running `vagrant ssh jenkins`.
5. Retrieve the initial admin password by running `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`. Copy the password to your clipboard.
6. Open `http://localhost:8080` in your web browser to access the Jenkins web interface.
7. When prompted, paste the initial admin password into the "Administrator Password" field and click "Continue".
8. On the "Customize Jenkins" page, click "Install suggested plugins" to install the recommended plugins.
9. Wait for the plugins to finish installing. This may take several minutes.
10. Click "Start using Jenkins" to open the Jenkins dashboard.
11. In the top-right corner of the page, click on your username and then click "Configure" in the drop-down menu.
12. Scroll down to the "API Token" section and click "Add new token".
13. Enter a name for the token (e.g., "My Token") and click "Generate".
14. Copy the generated token to your clipboard and save it somewhere safe, along with your Jenkins username. You'll need these later.
15. SSH into the Jenkins machine again by running `vagrant ssh jenkins`.
16. Navigate to the `/vagrant/shared` directory by running `cd /vagrant/shared`.
17. Run the `jenkins-docker-slave-setup.sh` script with your Jenkins username and API token as arguments, like this: `./jenkins-docker-slave-setup.sh <username> <token>`. Replace `<username>` and `<token>` with your actual Jenkins username and API token.

After completing these steps, your Jenkins instance should be set up and ready to use.

### Discord notifier

If you want to follow build steps, you can join this [discord](https://discord.gg/qRe9wNXQm), or copy this link `https://discord.gg/qRe9wNXQm`