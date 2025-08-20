### configuration parameters ###
BOX_BASE = "generic/centos8"
ADMIN_LOGIN = "hmaster"
ADMIN_PASS = "12qwaszx"
### /configuration parameters ###

Vagrant.configure("2") do |config|
  
    config.vm.box = BOX_BASE
    config.vm.boot_timeout = 600
   
    config.vm.define "KuberCentOS8" do |machine|
      machine.vm.hostname = "KuberCentOS8"
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
        h.vmname = "KuberCentOS8"
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

      machine.vm.provision :shell, :inline => "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;", run: "always"

      # Enable remote access with password
      machine.vm.provision "shell", inline: "
      sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
      systemctl restart sshd.service
      "

      # Create admin user and password
      # machine.vm.provision "shell", inline: "echo ubuntu:ubuntu | chpasswd"
      # ниже должно работать
      # sudo usermod -aG sudo $1
      # echo "%<user>      ALL=(ALL) ALL" | sudo tee -a /etc/sudoers > /dev/null
      # echo 'YOURUSERNAME ALL=(ALL:ALL) ALL' >> /etc/sudoers
      # sudo echo $1 ALL=(ALL:ALL) ALL >> /etc/sudoers      
      machine.vm.provision "shell" do |secure|
        secure.inline = "
        sudo useradd -p $(openssl passwd -1 $2) $1 -s /bin/bash -G wheel
        echo $1:$2 | sudo chpasswd
        "
        secure.args   = [ADMIN_LOGIN, ADMIN_PASS]
      end


      machine.vm.provision "shell", inline: "
      yum install hyperv-daemons
      yum list installed | grep hyperv
      systemctl status hypervvssd
      "

      # sudo yum install -y epel-release
      # sudo yum install -y ansible

      # sudo yum install -y yum-utils
      # sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
      # sudo yum install -y docker-ce docker-ce-cli containerd.io
      # sudo yum list docker-ce --showduplicates | sort -r
      # sudo systemctl enable docker
      # sudo systemctl start docker

      # sudo rm -rf /etc/cni/net.d /root/.kube /var/log/calico /run/calico /run/flannel /etc/kubernetes

      # # https://gist.github.com/iamcryptoki/ed6925ce95f047673e7709f23e0b9939
      # # Fix sysctl: cannot stat /proc/sys/net/bridge/bridge-nf-call-iptables.
      # sudo modprobe bridge
      # $ echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.conf
      # sudo sysctl -p /etc/sysctl.conf

      # # sysctl: cannot stat /proc/sys/net/bridge/bridge-nf-call-iptables: No such file or directory sysctl: cannot stat /proc/sys/net/bridge/bridge-nf-call-ip6tables: No such file or directory
      # # SOLUTION
      # sudo modprobe br_netfilter
      # sudo sysctl -p /etc/sysctl.conf


      # # https://github.com/kubernetes/kubeadm/issues/1893
      # The HTTP call equal to 'curl -sSL http://localhost:10248/healthz' failed with error: Get http://localhost:10248/healthz: dial tcp [::1]:10248: connect: connection refused.
      # reset kubeadm

      # I have stumbled up a similar issue. I have found the problem with 'journalctl -xeu kubelet'. My problem was cgroup driver. Kubernetes cgroup driver was set to systems but docker was set to systemd.
      # I added docker config file '/etc/docker/daemon.json' and added below to the file.
      # {
      # "exec-opts": ["native.cgroupdriver=systemd"]
      # }

      
      # sudo kubeadm init --control-plane-endpoint 192.168.1.117

      # mkdir -p $HOME/.kube
      # sudo cp --force /etc/kubernetes/admin.conf $HOME/.kube/config
      # sudo chown $(id -u):$(id -g) $HOME/.kube/config

      

    end

end
