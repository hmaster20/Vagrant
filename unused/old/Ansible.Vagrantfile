### configuration parameters ###
# Vagrant base box to use in Virtual Box
# BOX_BASE = "ubuntu/focal64"
# Vagrant base box to use in Hyper-V
BOX_BASE = "generic/ubuntu2004"
# local admin logopass
ADMIN_LOGIN = "ubuntu"
ADMIN_PASS = "ubuntu"
### /configuration parameters ###

Vagrant.configure("2") do |config|
  
    config.vm.box = BOX_BASE
   
    config.vm.define "Ansible" do |machine|
      machine.vm.hostname = "Ubuntu"
      machine.vm.synced_folder ".", "/vagrant", disabled: false 

      machine.vm.network "public_network", bridge: "Realtek"
      machine.vm.network "private_network", bridge: "Internal"

      machine.vm.provider "hyperv" do |h|
        h.vmname = "Ansible"
        h.cpus = 4
        h.maxmemory = 8192
        h.memory = 4096
        h.enable_virtualization_extensions = true   
      end

      # machine.vm.provision "shell", inline: "echo ubuntu:ubuntu | chpasswd"

      # machine.vm.provision "shell" do |secure|
      #   secure.inline = "echo $1:$2 | chpasswd"
      #   secure.args   = [ADMIN_LOGIN, ADMIN_PASS]
      # end

      machine.vm.provision "shell", inline: "
      apt-get update -yqq && apt-get install -y python-minimal
      apt-get install -y software-properties-common
      apt-add-repository ppa:ansible/ansible -y
      apt-get update -yqq
      apt-get install -y htop atop iotop mc nano git
      apt-get install -y ansible sshpass
      apt-get install -y linux-tools-virtual linux-cloud-tools-virtual
      apt-get install -y openvpn
      ip a | grep \"inet \"
      ansible --version
      cat /etc/os-release
      hostnamectl
      hostname -I
      "
      machine.vm.provision "shell", inline: <<-SHELL
      sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
      systemctl restart sshd.service
      SHELL

    end


    # https://github.com/microsoft/linux-vm-tools/blob/master/ubuntu/18.04/install.sh

    # echo "Installing Docker"
    # sudo apt-get -yqq update && sudo apt-get -yqq upgrade
    # curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    # sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    # sudo apt-get -yqq update
    # sudo apt-get -yqq install docker-ce
    # sudo usermod -aG docker vagrant

    # machine.vm.network "private_network",
    #   name: "vboxnet0", ip: "10.0.10.90"
    # machine.vm.network "forwarded_port",
    #   guest: 22, host: 2900
    # machine.ssh.guest_port = 2900
    # machine.vm.network "private_network", ip: "192.168.99.102"

end
