Vagrant.configure("2") do |config|
    # Jenkins VM configuration
    config.vm.define "jenkins" do |jenkins|
      jenkins.vm.box = "spox/ubuntu-arm"
      jenkins.vm.box_version = "1.0.0"
      jenkins.vm.network "forwarded_port", guest: 8080, host: 8080
      jenkins.vm.network "forwarded_port", guest: 3000, host: 3000
      jenkins.vm.network "forwarded_port", guest: 3100, host: 3100
      jenkins.vm.provider :vmware_desktop do |vmware|
        vmware.gui = true
        vmware.cpus = 4
        vmware.vmx["ethernet0.virtualdev"] = "vmxnet3"
        vmware.ssh_info_public = true
        vmware.linked_clone = false
      end
      jenkins.vm.provision "shell" do |shell|
        shell.path = "jenkins.sh"
      end
    end
  
    # Docker VM configuration
    config.vm.define "docker" do |docker|
      docker.vm.box = "spox/ubuntu-arm"
      docker.vm.box_version = "1.0.0"
      docker.vm.synced_folder "shared/", "/shared"
      docker.vm.network "forwarded_port", guest: 8080, host: 8081 # Changed host port to avoid conflict with Jenkins
      # open docker remote API port and hostport range 
      docker.vm.provider :vmware_desktop do |vmware|
        vmware.gui = true
        vmware.cpus = 4
        vmware.vmx["ethernet0.virtualdev"] = "vmxnet3"
        vmware.ssh_info_public = true
        vmware.linked_clone = false
      end
      docker.vm.provision "shell" do |shell|
        shell.path = "docker.sh"
      end
    end
  end