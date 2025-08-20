# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Before vagrant up, need run command to enable VT-X mode:
# cd C:\Program Files\Oracle\VirtualBox
# VBoxManage modifyvm <vm-name> --nested-hw-virt on
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# for info: https://stackoverflow.com/questions/54251855/virtualbox-enable-nested-vtx-amd-v-greyed-out
### configuration parameters ###
LOCAL_SSH_PORT = "2222"
# Vagrant base box to use
# config.vm.box = "ubuntu/bionic64/2021/v2"
BOX_BASE = "ubuntu/bionic64"
# amount of RAM for Vagrant box
BOX_RAM_MB = "2048"
# number of CPUs for Vagrant box
BOX_CPU_COUNT = "1"
# local admin logopass
ADMIN_LOGIN = "ubuntu"
ADMIN_PASS = "ubuntu"
### /configuration parameters ###

Vagrant.configure("2") do |config|

    config.vm.box = BOX_BASE
   
    config.vm.define "minikube" do |machine|
      machine.vm.hostname = "minikube"

      machine.vm.provider "virtualbox" do |vbox|
        # https://www.virtualbox.org/manual/ch08.html        
        vbox.customize ["modifyvm", :id, "--name", "minikube"]
        vbox.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
        vbox.customize ["modifyvm", :id, "--memory", "3072"]
        vbox.customize ["modifyvm", :id, "--cpus", "2"]
        vbox.customize ["modifyvm", :id, "--groups", "/k8s"]        
      end

      machine.vm.network "private_network", ip: "192.168.99.110"

      # machine.vm.provision "shell", inline: "echo ubuntu:ubuntu | chpasswd"
      machine.vm.provision "shell" do |secure|
        secure.inline = "echo $1:$2 | chpasswd"
        secure.args   = [ADMIN_LOGIN, ADMIN_PASS]
      end

      # # https://www.vagrantup.com/docs/synced-folders/basic_usage
      # machine.vm.synced_folder "../../GitLabRunner/", "/vagrant", 
      #   # disabled: false
      #   disabled: false,
      #   # id: "ansible-project",
      #   # owner: ADMIN_LOGIN,
      #   # group: ADMIN_LOGIN,
      #   # mount_options: ["dmode=775,fmode=664"]
      #   mount_options: ["dmode=777,fmode=666"]

      # machine.vm.network "private_network", ip: "192.168.99.100"
      # machine.vm.provision "shell", inline: "apt-get update && apt-get install -y python-minimal"
      # machine.vm.provision "ansible", playbook: "consul.yml"      

      # Enable remote access via password
      machine.vm.provision "shell", inline: <<-SHELL
      sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
      systemctl restart sshd.service
      SHELL
      
      # Install other tools
      machine.vm.provision "shell", inline: "
      apt-get update -y
      apt-get install -y htop iotop mc nano
      "

      # Install VirtualBox and Extension Pack
      machine.vm.provision "shell", inline: "
      sudo apt install -y gcc make linux-headers-$(uname -r) dkms
      sudo apt-get install -y software–properties–common
      sudo sed -i 's%GPG_CMD=\"gpg %GPG_CMD=\"gpg --batch %g' /usr/bin/apt-key
      export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=true
      wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
      wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
      echo \"deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib\" | sudo tee /etc/apt/sources.list.d/virtualbox.list
      sudo apt-get -y update
      export packversion=$(curl -s https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT)
      export shortversion=${packversion%.*}
      printenv shortversion
      sudo apt install -y virtualbox-$shortversion
      sudo curl -LO https://download.virtualbox.org/virtualbox/`curl -s https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT`/Oracle_VM_VirtualBox_Extension_Pack-`curl -s https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT`.vbox-extpack
      echo \"y\" | sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-`curl -s https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT`.vbox-extpack
      "

      # Install Ansible 2.9
      machine.vm.provision "shell", inline: "
      apt-get update && apt-get install -y python-minimal
      apt-get install -y software-properties-common
      apt-add-repository ppa:ansible/ansible -y
      apt-get update -y
      apt-get install -y ansible sshpass
      ansible --version
      "

      # Install Docker
      machine.vm.provision "shell", inline: "
      echo \"Installing Docker\"
      echo \"Without setup bionic may be used $(lsb_release -cs)\"
      sudo apt-get -yqq update && sudo apt-get -yqq upgrade
      sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
      sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable\"
      sudo apt-get -yqq update
      sudo apt-get -yqq install docker-ce
      sudo usermod -aG docker vagrant
      docker --version
      "

      # Install Docker Compose
      machine.vm.provision "shell", inline: "
      echo \"Installing Docker Compose\"
      echo \"Without setup docker-compose-Linux-x86_64 may be used docker-compose-$(uname -s)-$(uname -m)\"
      sudo curl -L \"https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64\" -o /usr/local/bin/docker-compose
      sudo chmod +x /usr/local/bin/docker-compose
      sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
      docker-compose --version
      "

      # Install Kubectl
      machine.vm.provision "shell", inline: "
      sudo apt-get update -y
      sudo apt-get install -y curl apt-transport-https
      sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
      sudo chmod +x ./kubectl
      sudo mv ./kubectl /usr/local/bin/kubectl
      kubectl version --client
      "

      # Install Helm
      machine.vm.provision "shell", inline: "
      curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
      sudo apt-get install -y apt-transport-https --yes
      echo \"deb https://baltocdn.com/helm/stable/debian/ all main\" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
      sudo apt-get update -y
      sudo apt-get install -y helm
      "

      # Install minikube
      machine.vm.provision "shell", inline: "
      curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube
      sudo install minikube /usr/local/bin/
      minikube start --kubernetes-version v1.18.0 --cpus='2' --memory='2000mb' --disk-size='5000mb'
      minikube status
      "
       
    end

end
