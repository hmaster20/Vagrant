# -*- mode: ruby -*-
# vi: set ft=ruby :
# ---------------------------------
# https://stackoverflow.com/questions/54251855/virtualbox-enable-nested-vtx-amd-v-greyed-out
# Before vagrant up, need run command to enable VT-X mode:
# cd C:\Program Files\Oracle\VirtualBox
# VBoxManage modifyvm <vm-name> --nested-hw-virt on
# ---------------------------------
BOX_BASE = "ubuntu/focal64"
ADMIN_LOGIN = "ubuntu"
ADMIN_PASS = "ubuntu"
# ---------------------------------
MAC_ADDR = "080027ABC045"
IP_ADDR = "192.168.1.45"
HOST_ADDR = "repo.local"
VM_GROUP = "/local"
VM_DESCR = "APT repository for Ubuntu 20.04 LTS (Focal Fossa)"
# ---------------------------------
IP_ADDR_PRIVATE = "192.168.50.45"
# ---------------------------------
CPU_COUNT = "1"     # "2"
CPU_USAGE = "80"    # Percent usage 75
RAM_SIZE = "1024"   # 2048 3072 4096
# ---------------------------------
# fix multipath daemon error
# https://sleeplessbeastie.eu/2021/01/06/how-to-fix-multipath-daemon-error-about-missing-path-when-using-virtualbox/
$multipath_daemon=<<SCRIPT
cat <<EOF | sudo tee -a /etc/multipath.conf
blacklist {
  device {
    vendor \"VBOX\"
    product \"HARDDISK\"
  }
}
EOF
SCRIPT
# ---------------------------------
# https://wiki.debian.org/AptCacherNg
# Проксируем все репозитории HTTPS
$apt_cacher_proxy_https=<<SCRIPT
cat <<EOF | sudo tee -a /etc/apt-cacher-ng/acng.conf
PassThroughPattern: ^(.*):443$
EOF
SCRIPT
# ---------------------------------
# ---------------------------------

Vagrant.configure("2") do |config|

    config.vm.box = BOX_BASE

    config.vm.define HOST_ADDR do |machine|
      machine.vm.hostname = HOST_ADDR
      machine.vm.provider "virtualbox" do |vbox|

      # https://developer.hashicorp.com/vagrant/docs/vagrantfile/machine_settings
      # Отключить проверку репозитория на наличие новых версий для текущего box-а
      machine.vm.box_check_update = false

        # Customize VM
        # https://www.virtualbox.org/manual/ch08.html
        vbox.customize ["modifyvm", :id, "--cpus", CPU_COUNT ]
        vbox.customize ["modifyvm", :id, "--cpuexecutioncap", CPU_USAGE ]
        vbox.customize ["modifyvm", :id, "--memory", RAM_SIZE ]
        vbox.customize ["modifyvm", :id, "--name", HOST_ADDR ]
        vbox.customize ["modifyvm", :id, "--groups", VM_GROUP ]
        vbox.customize ["modifyvm", :id, "--description", VM_DESCR ]

        # Отключить проверку гостевых дополнений
        vbox.check_guest_additions = false
        # # Отключить использование подключаемых каталогов
        # vbox.functional_vboxsf     = false

      end

      # WiFi (DHCP)
      # machine.vm.network "public_network", 
      #   bridge: 'Hyper-V Virtual Ethernet Adapter #2', 
      #   :ipv6 => false, 
      #   :mac => "080027C43B24"

      # WiFi (Static)
      machine.vm.network "public_network",
        bridge: 'Intel(R) Dual Band Wireless-AC 7260',
        ip: IP_ADDR,
        :ipv6 => false,
        :mac => MAC_ADDR

      # Internal VirtualBox Network
      machine.vm.network "private_network", ip: IP_ADDR_PRIVATE, virtualbox__intnet: true

      # machine.vm.provision "shell", inline: "echo 'ubuntu:ubuntu' | sudo chpasswd"
      machine.vm.provision "shell" do |secure|
        secure.inline = "echo $1:$2 | chpasswd"
        secure.args   = [ADMIN_LOGIN, ADMIN_PASS]
      end

      machine.vm.synced_folder ".", "/vagrant",  disabled: true
      # https://www.vagrantup.com/docs/synced-folders/basic_usage
      machine.vm.synced_folder "./cache", "/var/cache/apt-cacher-ng",
        disabled: false,
        id: "apt-cacher-ng-project",
        owner: "apt-cacher-ng",
        group: "apt-cacher-ng",
        # mount_options: ["dmode=775,fmode=664"]
        mount_options: ["dmode=755,fmode=755"]

      # Enable remote access via password
      machine.vm.provision "shell", inline: <<-SHELL
      sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
      systemctl restart sshd.service
      SHELL

      # Install other tools
      # sudo apt-get -yqq update && sudo apt-get -yqq upgrade
      machine.vm.provision "shell", inline: "
      sudo apt-get -yqq update
      sudo apt-get install -yq --no-install-recommends \
      nano mc htop atop iotop iftop git net-tools dnsutils bash-completion jq
      "

      # fix multipath daemon error
      # machine.vm.provision :shell, inline: $multipath_daemon, args: "#{master_ip}"
      machine.vm.provision :shell, inline: $multipath_daemon
      machine.vm.provision "shell", inline: "sudo systemctl restart multipathd.service"

      # https://www.ylsoftware.com/news/740
      # https://wiki.debian.org/AptCacherNg
      # Install apt-cacher-ng
      machine.vm.provision "shell", inline: "
      sudo apt-get install -yq --no-install-recommends \
      apt-cacher-ng \
      avahi-daemon
      "

      # Проксируем все репозитории HTTPS
      machine.vm.provision :shell, :inline => $apt_cacher_proxy_https

      # View VM info
      machine.vm.provision "shell", inline: "
      ip a | grep \"inet \"
      cat /etc/os-release
      hostnamectl
      hostname -I
      lscpu | grep VT-x
      ", run: "always"

      # Перезагрузка
      # machine.vm.provision :reload


    end

end

# get-process | where ProcessName -like *ruby*
# get-process | findstr ruby
# $procid=get-process ruby |select -expand id
# $procid=(get-process ruby).id
# stop-process $procid
# stop-process 11222
