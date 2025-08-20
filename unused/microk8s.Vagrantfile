# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# https://stackoverflow.com/questions/54251855/virtualbox-enable-nested-vtx-amd-v-greyed-out
# Before vagrant up, need run command to enable VT-X mode:
# cd C:\Program Files\Oracle\VirtualBox
# VBoxManage modifyvm <vm-name> --nested-hw-virt on
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

### configuration parameters ###
# BOX_BASE = "generic/ubuntu2004"
# focal64 is Ubuntu 20.04 | cat /etc/os-release

BOX_BASE = "ubuntu/focal64"
ADMIN_LOGIN = "ubuntu"
ADMIN_PASS = "ubuntu"

# Основные параметры описаны => https://developer.hashicorp.com/vagrant/docs/vagrantfile/machine_settings

Vagrant.configure("2") do |config|

    config.vm.box = BOX_BASE

    config.vm.define "microStatic" do |machine|
      machine.vm.hostname = "microStatic"

      machine.vm.provider "virtualbox" do |vbox|
        # https://www.virtualbox.org/manual/ch08.html
        vbox.customize ["modifyvm", :id, "--name", "microStatic"]
        vbox.customize ["modifyvm", :id, "--cpus", "2"]
        vbox.customize ["modifyvm", :id, "--cpuexecutioncap", "95"]
        # vbox.customize ["modifyvm", :id, "--memory", "3072"]
        vbox.customize ["modifyvm", :id, "--memory", "4096"]
        vbox.customize ["modifyvm", :id, "--groups", "/K8s"]
      end

      # WiFi (DHCP)
      # machine.vm.network "public_network", 
      #   bridge: 'Hyper-V Virtual Ethernet Adapter #2', 
      #   :ipv6 => false, 
      #   :mac => "080027C43B24"

      # WiFi (Static)
      machine.vm.network "public_network", 
        bridge: 'Hyper-V Virtual Ethernet Adapter #2', 
        ip: "192.168.1.116",
        :ipv6 => false, 
        :mac => "080027C43B34"

      machine.vm.synced_folder "D:\\GitHub\\apps", "/application",
        # disabled: false
        disabled: false,
        # id: "ansible-project",
        # owner: ADMIN_LOGIN,
        # group: ADMIN_LOGIN,
        # mount_options: ["dmode=775,fmode=664"]
        mount_options: ["dmode=777,fmode=666"]

      # # https://www.vagrantup.com/docs/synced-folders/basic_usage
      # machine.vm.synced_folder "../../GitLabRunner/", "/vagrant", 
      #   # disabled: false
      #   disabled: false,
      #   # id: "ansible-project",
      #   # owner: ADMIN_LOGIN,
      #   # group: ADMIN_LOGIN,
      #   # mount_options: ["dmode=775,fmode=664"]
      #   mount_options: ["dmode=777,fmode=666"]

      # Set new user and password
      # machine.vm.provision "shell", inline: "echo 'ubuntu:ubuntu' | sudo chpasswd"
      machine.vm.provision "shell" do |secure|
        secure.inline = "echo $1:$2 | chpasswd"
        secure.args   = [ADMIN_LOGIN, ADMIN_PASS]
      end

      # Enable remote access via password
      machine.vm.provision "shell", inline: <<-SHELL
      sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
      systemctl restart sshd.service
      SHELL
    
      # Install other tools
      machine.vm.provision "shell", inline: "
      sudo apt-get -yqq update
      sudo apt-get install -yq htop iotop mc nano git net-tools dnsutils
      "

      # Установку VirtualBox Guest Additions выполняем один раз, они сильно удлиняют развертывание!
      # ============================================================================================================== |
      # Before installing the guest additions, you will need the Linux kernel headers and the basic developer tools.
      # machine.vm.provision "shell", inline: "
      # sudo apt-get install -yq linux-headers-$(uname -r) build-essential dkms
      # "

      # # VirtualBox Guest Additions
      # machine.vm.provision "shell", inline: "
      # export packversion=$(curl -s https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT)
      # printenv packversion
      # [ -f ./VBoxGuestAdditions_${packversion}.iso ] && echo \"File exist\" || wget http://download.virtualbox.org/virtualbox/${packversion}/VBoxGuestAdditions_${packversion}.iso
      # sudo mkdir /media/VBoxGuestAdditions
      # sudo mount -o loop,ro VBoxGuestAdditions_${packversion}.iso /media/VBoxGuestAdditions
      # echo \"yes\" | sudo sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run
      # rm VBoxGuestAdditions_${packversion}.iso
      # sudo umount /media/VBoxGuestAdditions
      # "
      # ============================================================================================================== |


      # Ниже представлена старая версия разертывания VirtualBox + Extension Pack
      # Install VirtualBox and Extension Pack
      # machine.vm.provision "shell", inline: "
      # sudo apt install -y gcc make linux-headers-$(uname -r) dkms
      # sudo apt-get install -y software–properties–common
      # sudo sed -i 's%GPG_CMD=\"gpg %GPG_CMD=\"gpg --batch %g' /usr/bin/apt-key
      # export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=true
      # wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
      # wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
      # echo \"deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib\" | sudo tee /etc/apt/sources.list.d/virtualbox.list
      # sudo apt-get -y update
      # export packversion=$(curl -s https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT)
      # export shortversion=${packversion%.*}
      # printenv shortversion
      # sudo apt install -y virtualbox-$shortversion
      # sudo curl -LO https://download.virtualbox.org/virtualbox/`curl -s https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT`/Oracle_VM_VirtualBox_Extension_Pack-`curl -s https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT`.vbox-extpack
      # echo \"y\" | sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-`curl -s https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT`.vbox-extpack
      # "

      # machine.vm.provision "shell", inline: "apt-get update && apt-get install -y python-minimal"
      # machine.vm.provision "ansible", playbook: "consul.yml"

      # Install Ansible 2.9
      machine.vm.provision "shell", inline: "
      apt-get install -y software-properties-common
      apt-add-repository ppa:ansible/ansible -y
      apt-get update -y
      apt-get install -y ansible sshpass
      ansible --version
      "

      # Install Docker
      machine.vm.provision "shell", inline: "
      echo \"Installing Docker for $(lsb_release -cs)\"
      sudo apt-get -yqq update && sudo apt-get -yqq upgrade
      sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
      sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable\"
      sudo apt-get -yqq update
      sudo apt-get -yqq install docker-ce docker-ce-cli containerd.io docker-compose-plugin
      sudo usermod -aG docker vagrant
      sudo usermod -aG docker ubuntu
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

      # Install Kubernetes Utils
      machine.vm.provision "shell", inline: "
      echo \"Installing Kubernetes Utils\"
      sudo apt-get install -y apt-transport-https ca-certificates curl
      sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
      echo \"deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main\" | sudo tee /etc/apt/sources.list.d/kubernetes.list
      sudo apt-get update
      sudo apt-get install -y kubelet kubeadm kubectl
      sudo apt-mark hold kubelet kubeadm kubectl
      "

      # Install Helm
      machine.vm.provision "shell", inline: "
      echo \"Installing Helm\"
      curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
      sudo apt-get install -y apt-transport-https --yes
      echo \"deb https://baltocdn.com/helm/stable/debian/ all main\" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
      sudo apt-get update -y
      sudo apt-get install -y helm
      "

      # Install minikube
      # machine.vm.provision "shell", inline: "
      # curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube
      # sudo install minikube /usr/local/bin/
      # minikube start --kubernetes-version v1.18.0 --cpus='2' --memory='2000mb' --disk-size='5000mb'
      # minikube status
      # "

      # Install microk8s | istio
      machine.vm.provision "shell", inline: "
      echo \"Installing microk8s\"
      sudo snap install microk8s --classic
      microk8s enable dashboard
      microk8s status --wait-ready      
      microk8s enable dns
      microk8s enable registry
      microk8s enable community
      microk8s enable ingress hostpath-storage
      microk8s status
      sudo usermod -a -G microk8s ubuntu
      sudo chown -f -R ubuntu ~/.kube
      newgrp microk8s
      "

      # # OpenVPN
      machine.vm.provision "shell", inline: "
      echo \"deb https://repo.pritunl.com/stable/apt focal main\" | sudo tee /etc/apt/sources.list.d/pritunl.list
      sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7AE645C0CF8E292A
      sudo apt update -yq
      sudo apt install -yq pritunl-client-electron pritunl-client
      sudo apt install -yq network-manager network-manager-openvpn
      "
      # sudo nmcli connection import type openvpn file ar-develop-ru_biryukovsa_ar-develop-ru.ovpn
      # nmcli connection up ar-develop-ru_biryukovsa_ar-develop-ru
      # pritunl-client add ar-develop-ru_biryukovsa_ar-develop-ru.ovpn
      # sudo openvpn ar-develop-ru_biryukovsa_ar-develop-ru.ovpn


      # fix multipath daemon error
      # https://sleeplessbeastie.eu/2021/01/06/how-to-fix-multipath-daemon-error-about-missing-path-when-using-virtualbox/
      machine.vm.provision "shell", inline: "
      cat <<EOF | sudo tee -a /etc/multipath.conf
      blacklist {
        device {
          vendor \"VBOX\"
          product \"HARDDISK\"
        }
      }
      EOF
      sudo systemctl restart multipathd.service
      "

      # View VM info
      machine.vm.provision "shell", inline: "
      ip a | grep \"inet \"
      cat /etc/os-release
      hostnamectl
      hostname -I
      lscpu | grep VT-x
      "

    end

    # # Файловый сервер

    # config.vm.define "microStaticNFS" do |nfs|
    #   nfs.vm.hostname = "microStaticNFS"

    #   nfs.vm.provider "virtualbox" do |vbox|
    #     vbox.customize ["modifyvm", :id, "--name", "microStaticNFS"]
    #     vbox.customize ["modifyvm", :id, "--cpus", "2"]
    #     vbox.customize ["modifyvm", :id, "--cpuexecutioncap", "80"]
    #     vbox.customize ["modifyvm", :id, "--memory", "3072"]
    #     vbox.customize ["modifyvm", :id, "--groups", "/K8s"]
    #   end

      
    #   # WiFi (DHCP)
    #   # machine.vm.network "public_network", 
    #   #   bridge: 'Hyper-V Virtual Ethernet Adapter #2', 
    #   #   :ipv6 => false, 
    #   #   :mac => "080027C43B24"

    #   # WiFi (Static)
    #   nfs.vm.network "public_network", 
    #     bridge: 'Hyper-V Virtual Ethernet Adapter #2', 
    #     ip: "192.168.1.116",
    #     :ipv6 => false, 
    #     :mac => "080027C43B34"

    #   # Set new user and password
    #   # nfs.vm.provision "shell", inline: "echo 'ubuntu:ubuntu' | sudo chpasswd"
    #   nfs.vm.provision "shell" do |secure|
    #     secure.inline = "echo $1:$2 | chpasswd"
    #     secure.args   = [ADMIN_LOGIN, ADMIN_PASS]
    #   end

    #   # Enable remote access via password
    #   nfs.vm.provision "shell", inline: <<-SHELL
    #   sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    #   systemctl restart sshd.service
    #   SHELL
    
    #   # Install other tools
    #   nfs.vm.provision "shell", inline: "
    #   sudo apt-get -yqq update
    #   sudo apt-get install -yq htop iotop mc nano git net-tools dnsutils
    #   "

    #   nfs.vm.provision "shell", inline: "
    #   yum install nfs-utils -y
    #   systemctl enable rpcbind --
    #   systemctl enable nfs-server
    #   systemctl start rpcbind
    #   systemctl start nfs-server
    #   "

    # end 

end

# get-process | where ProcessName -like *ruby*
# get-process | findstr ruby
# $procid=get-process ruby |select -expand id
# $procid=(get-process ruby).id
# stop-process $procid
# stop-process 11222
