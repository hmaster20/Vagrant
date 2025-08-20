### configuration parameters ###
# Vagrant base box to use in Virtual Box
# BOX_BASE = "ubuntu/focal64"
# Vagrant base box to use in Hyper-V
# BOX_BASE = "generic/ubuntu2004"
BOX_BASE = "generic/ubuntu1804"
ADMIN_LOGIN = "ubuntu"
ADMIN_PASS = "ubuntu"
### /configuration parameters ###

Vagrant.configure("2") do |config|
  
    config.vm.box = BOX_BASE
    config.vm.boot_timeout = 600
   
    config.vm.define "K8s" do |machine|
      machine.vm.hostname = "K8s"
      machine.vm.synced_folder ".", "/vagrant", disabled: true 

      # https://www.vagrantup.com/docs/networking/public_network
      machine.vm.network "public_network", bridge: "Intel7260"
      # machine.vm.network "public_network", bridge: "KillerE2200"
      # machine.vm.network "private_network", bridge: "Internal"
      # machine.vm.network "private_network", ip: "192.168.33.10"
      # machine.vm.network "private_network", ip: "192.168.33.20"
      # machine.vm.network "public_network", type: "dhcp", bridge: "eth0"

      # https://www.vagrantup.com/docs/providers/hyperv/configuration
      machine.vm.provider "hyperv" do |h|
        h.vmname = "K8s"
        h.cpus = 4
        h.maxmemory = 8192
        h.memory = 4096
        h.enable_virtualization_extensions = true
        h.vm_integration_services = {
          guest_service_interface: true,
          heartbeat: true,
          time_synchronization: true
        }
      end

      # Create admin user and password
      # machine.vm.provision "shell", inline: "echo ubuntu:ubuntu | chpasswd"
      machine.vm.provision "shell" do |secure|
        secure.inline = "
        sudo useradd -s /bin/bash -d /home/$1/ -m -G sudo $1
        echo $1:$2 | sudo chpasswd
        "
        secure.args   = [ADMIN_LOGIN, ADMIN_PASS]
      end

      # Enable remote access with password
      machine.vm.provision "shell", inline: "
      sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
      systemctl restart sshd.service
      "

      # Install addon tools
      machine.vm.provision "shell", inline: "
      apt-get update -yqq
      apt-get install -y passwd
      apt-get install -y htop atop iotop mc nano git
      "

      # Install Hyper-V Guest Tools
      machine.vm.provision "shell", inline: "
      echo \"Installing Hyper-V Guest Tools\"
      apt-get update -yqq
      apt-get install -y linux-tools-virtual linux-cloud-tools-virtual
      "
       
      # Install Ansible latest
      machine.vm.provision "shell", inline: "
      echo \"Installing Ansible\"
      apt-get update && apt-get install -y python-minimal
      apt-get install -y software-properties-common
      apt-add-repository ppa:ansible/ansible -y
      apt-get update -y
      apt-get install -y ansible sshpass
      ansible --version
      "

      # Install Docker for Ubuntu 18 (bionic)
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

      # Install Helm
      machine.vm.provision "shell", inline: "
      echo \"Installing Helm\"
      curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
      sudo apt-get install -y apt-transport-https --yes
      echo \"deb https://baltocdn.com/helm/stable/debian/ all main\" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
      sudo apt-get update -y
      sudo apt-get install -y helm
      "   

      # Install Kubectl
      # https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
      # machine.vm.provision "shell", inline: "
      # sudo apt-get update -y
      # sudo apt-get install -y curl apt-transport-https
      # sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
      # sudo chmod +x ./kubectl
      # sudo mv ./kubectl /usr/local/bin/kubectl
      # kubectl version --client
      # "

      # Install Kubernetes
      machine.vm.provision "shell", inline: "
      echo \"Installing Kubernetes\"      
      echo br_netfilter > /etc/modules-load.d/k8s.conf
      echo net.bridge.bridge-nf-call-ip6tables = 1 > /etc/sysctl.d/k8s.conf
      echo net.bridge.bridge-nf-call-iptables = 1 >> /etc/sysctl.d/k8s.conf
      sudo sysctl --system
      sudo apt-get install -y apt-transport-https ca-certificates curl
      sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
      echo \"deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main\" | sudo tee /etc/apt/sources.list.d/kubernetes.list
      sudo apt-get update -yqq
      sudo apt-get install -y kubeadm kubelet kubectl
      sudo apt-mark hold kubeadm kubelet kubectl
      kubeadm version
      kubectl version --client
      "

      # Fix problem: hv_kvp_daemon ... /usr/libexec/hypervkvpd/hv_get_dhcp_info: not found
      machine.vm.provision "shell", inline: "
      sudo apt-get install -y linux-image-virtual-hwe-18.04 linux-image-extra-virtual
      "

      # Config VM for Kubernetes
      # https://phoenixnap.com/kb/install-kubernetes-on-ubuntu
      # machine.vm.provision "shell", inline: "
      # sudo apt install -y gcc make linux-headers-$(uname -r) dkms 

      # sudo swapoff -a
      # sudo sed -i '/ swap / s/^/#/' /etc/fstab      
      # sudo hostnamectl set-hostname master-node
      # sudo kubeadm init --control-plane-endpoint 192.168.1.215 --pod-network-cidr=10.244.0.0/16
      # mkdir -p $HOME/.kube
      # sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
      # sudo chown $(id -u):$(id -g) $HOME/.kube/config
      # sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
      # helm upgrade --install ingress-nginx ingress-nginx \
      #   --repo https://kubernetes.github.io/ingress-nginx \
      #   --namespace ingress-nginx --create-namespace \
      #   --set controller.service.externalIPs=\"{$(hostname -I | awk '{print $1}')}\"
      # kubectl taint nodes --all node-role.kubernetes.io/master-
      # kubectl get pods --all-namespaces        
      # "


      # sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
      # sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
      # sudo apt-get install kubeadm kubelet kubectl
      # sudo apt-mark hold kubeadm kubelet kubectl
      # kubeadm version

   

      # View VM info
      machine.vm.provision "shell", inline: "
      ip a | grep \"inet \"
      cat /etc/os-release
      hostnamectl
      hostname -I
      lscpu | grep VT-x
      "

    end

end
