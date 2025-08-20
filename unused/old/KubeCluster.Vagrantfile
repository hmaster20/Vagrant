# Need install plugin "reload":
# vagrant plugin install vagrant-reload

BOX_BASE = "generic/ubuntu1804"
ADMIN_LOGIN = "ubuntu"
ADMIN_PASS = "ubuntu"

Vagrant.configure("2") do |config|
  
    config.vm.box = BOX_BASE
    config.vm.boot_timeout = 600
   
    config.vm.define "KubeCluster" do |machine|
      machine.vm.hostname = "KubeCluster"
      # machine.vm.synced_folder ".", "/vagrant", disabled: true 

      # https://www.vagrantup.com/docs/synced-folders/smb.html#smb_username
      # machine.vm.synced_folder "../../contrib", "/var/contrib", type: "smb",
      #   smb_password: "password", smb_username: "ubuntu",
      #   mount_options: ["username=ubuntu","password=password"]

        # smb_password: "password", smb_username: "mymail@live.ru",
        # mount_options: ["username=mymail@live.ru","password=password"]             
    
      # https://stackoverflow.com/questions/12538162/setting-a-vms-mac-address-in-vagrant

      machine.vm.network "public_network", bridge: "Intel7260", :ipv6 => false, :mac => "00F9965B96DE", auto_config: false # WiFi
      # machine.vm.network "public_network", bridge: "Intel7260", :ipv6 => false, :mac => "00F9965B96DE"         # WiFi
      # machine.vm.network "public_network", 
      #   bridge: "Intel7260", 
      #   ip: "192.168.1.11",
      #   # netmask: "24",
      #   # hostname: true,
      #   # :ipv6 => false, 
      #   :mac => "00F9965B96DE", 
      #   auto_config: false    # WiFi
      

      # https://www.vagrantup.com/docs/providers/hyperv/configuration
      machine.vm.provider "hyperv" do |h|
        h.vmname = "KubeCluster"
        h.cpus = 4
        h.maxmemory = 8192
        h.memory = 4096
        h.mac = "00F9965B96DE"
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

      # RedHat, CentOS, and Oracle Linux Example
      # machine.vm.provision "shell", inline: "
      # echo \"Setting static IP address for Hyper-V...\"
      # cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth0
      # DEVICE=eth0
      # BOOTPROTO=none
      # ONBOOT=yes
      # PREFIX=24
      # IPADDR=192.168.0.2
      # GATEWAY=192.168.0.1
      # DNS1=8.8.8.8
      # "

      # Ubuntu 18.04 LTS Example
      machine.vm.provision "shell", inline: "
      echo \"Setting static IP address for Hyper-V...\"
      cat << EOF > /etc/netplan/01-netcfg.yaml
      network:
        version: 2
        ethernets:
          eth0:
            dhcp4: no
            addresses: [192.168.1.11/24]
            gateway4: 192.168.1.1
            nameservers:
              addresses: [8.8.8.8,8.8.4.4]
      "
     

      # config.vm.provision :reload

      # # Install addon tools
      # machine.vm.provision "shell", inline: "
      # apt-get update -yqq
      # apt-get install -y passwd
      # apt-get install -y htop atop iotop mc nano git
      # "

      # # Install Hyper-V Guest Tools
      # machine.vm.provision "shell", inline: "
      # echo \"Installing Hyper-V Guest Tools\"
      # apt-get update -yqq
      # apt-get install -y linux-tools-virtual linux-cloud-tools-virtual
      # "

      # Disable IPv6
      machine.vm.provision "shell", inline: "
      echo \"net.ipv6.conf.all.disable_ipv6=1\" >>  /etc/sysctl.conf
      echo \"net.ipv6.conf.default.disable_ipv6=1\" >>  /etc/sysctl.conf
      echo \"net.ipv6.conf.lo.disable_ipv6=1\" >>  /etc/sysctl.conf    
      echo \"net.ipv6.conf.eth0.disable_ipv6=1\" >>  /etc/sysctl.conf    
      sudo sysctl -p
      "

      # reboot VM
      machine.vm.provision :reload

      # View VM info
      machine.vm.provision "shell", inline: "
      ip a | grep \"inet \"
      cat /etc/os-release
      hostnamectl
      hostname -I
      lscpu | grep VT-x
      "
    

      # Install K8s
      # machine.vm.provision "shell", inline: "
      # cd /var/contrib
      # bash ./kubecluster.sh install
      # "

    end

end


# get-process | where ProcessName -like *ruby*
# get-process | findstr ruby
# $procid=get-process ruby |select -expand id
# $procid=(get-process ruby).id
# stop-process 11222
