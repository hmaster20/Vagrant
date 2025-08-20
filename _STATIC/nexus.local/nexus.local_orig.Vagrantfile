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
CPU_COUNT = "4"     # vCores 2 3 4
CPU_USAGE = "85"    # Percent usage 75 95
RAM_SIZE = "3072"   # 1024 2048 3072 4096
# ---------------------------------
MAC_ADDR = "080027ABC044"
IP_ADDR = "192.168.1.44"       #  Bridge
IP_LOCL = "192.168.50.44"      #  Internal
IP_HOST = "192.168.56.44"      #  Host-Only
# ---------------------------------
HOST_ADDR = "nexus.local"
VM_GROUP = "/local"
VM_DESCR = "Nexus 3 repository for Ubuntu 20.04 LTS Focal"
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
# fix auto upgrades
$disable_auto_upgrades=<<SCRIPT
cat <<EOF | sudo tee /etc/apt/apt.conf.d/20auto-upgrades
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Download-Upgradeable-Packages "0";
APT::Periodic::AutocleanInterval "0";
APT::Periodic::Unattended-Upgrade "0";
EOF
SCRIPT
# ---------------------------------
DOCKER_INSECURE_REGISTRIES='"172.17.21.6:2222","172.17.21.6:4444","172.17.21.109:5000"'
DOCKER_REGISTRY_MIRRORS='"http://172.17.21.6:4444"'
$docker_daemon_config=<<SCRIPT
cat <<EOF | sudo tee /etc/docker/daemon.json > /dev/null
{
    "bip": "100.64.0.1/24",
    "builder": {
        "gc": {
            "defaultKeepStorage": "10GB",
            "enabled": true
        }
    },
    "containerd-namespace": "default",
    "default-address-pools": [
        {
            "base": "100.65.0.0/16",
            "size": 25
        }
    ],
    "exec-opts": ["native.cgroupdriver=systemd"],
    "features": {
        "buildkit": true
    },
    "log-driver": "json-file",
    "log-opts": {
        "max-file": "5",
        "max-size": "50m",
        "tag": "{{.ImageName}}|{{.Name}}|{{.ImageFullID}}|{{.FullID}}"
    },
    "insecure-registries": [
      $1
    ],
    "registry-mirrors": [
      $2
    ],
    "storage-driver": "overlay2"
}
EOF
SCRIPT
# ---------------------------------
# ---------------------------------

Vagrant.configure("2") do |config|

    # Базовый образ
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

      # ---------------------------------------------------------------------
      # WiFi (Static)
      # ==============
      # For check exist bridges:
      # "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" list bridgedifs
      # ==============
      machine.vm.network "public_network",
        bridge: 'Intel(R) Dual Band Wireless-AC 7260',
        ip: IP_ADDR,
        :ipv6 => false,
        :mac => MAC_ADDR

      # Internal network
      machine.vm.network "private_network",
        virtualbox__intnet: true,
        ip: IP_LOCL,
        :ipv6 => false

      # Private network
      machine.vm.network "private_network",
        name: "VirtualBox Host-Only Ethernet Adapter",
        ip: IP_HOST,
        :ipv6 => false
      # ---------------------------------------------------------------------

      # machine.vm.synced_folder ".", "/vagrant",  disabled: true
      # # https://www.vagrantup.com/docs/synced-folders/basic_usage
      # machine.vm.synced_folder "D:\\GitHub\\apps", "/application",
      #   disabled: false,
      #   # id: "ansible-project",
      #   # owner: ADMIN_LOGIN,
      #   # group: ADMIN_LOGIN,
      #   # mount_options: ["dmode=775,fmode=664"]
      #   mount_options: ["dmode=777,fmode=666"]

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

      # fix multipath daemon error
      # machine.vm.provision :shell, inline: $multipath_daemon, args: "#{master_ip}"
      machine.vm.provision :shell, inline: $multipath_daemon
      machine.vm.provision "shell", inline: "sudo systemctl restart multipathd.service"

      # fix auto upgrades
      machine.vm.provision :shell, inline: $disable_auto_upgrades
      machine.vm.provision "shell", inline: "
      sudo apt remove -yq unattended-upgrades
      sudo apt purge -y unattended-upgrades
      sudo apt remove -yq cron-apt
      "

      # Install other tools
      # sudo apt-get -yqq update && sudo apt-get -yqq upgrade
      machine.vm.provision "shell", inline: "
      sudo apt-get -yqq update
      sudo apt-get install -yq --no-install-recommends \
      nano mc htop atop iotop iftop git net-tools dnsutils bash-completion jq
      "

      # Install Docker
      # ==============
      # https://stackoverflow.com/questions/58741267/containerd-io-vs-docker-ce-cli-vs-docker-ce-what-are-the-differences-and-what-d
      # containerd.io : демон containerd . Он работает независимо от пакетов докеров и требуется для пакетов докеров.
      #   containerd доступен как демон для Linux и Windows. Он управляет полным жизненным циклом контейнера своей хост-системы, от передачи и хранения образов до выполнения и наблюдения за контейнером, низкоуровневого хранилища, сетевых подключений и т. д.
      # docker-ce-cli : интерфейс командной строки для движка Docker, версия сообщества
      # docker-ce : механизм докера , версия для сообщества. Требуется docker-ce-cli.
      # ==============
      machine.vm.provision "shell", inline: "
      echo \"Installing Docker\"
      echo \"$(lsb_release -cs)\"
      sudo apt-get install ca-certificates curl gnupg lsb-release
      sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
      sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable\"
      sudo apt-get -yqq update
      sudo apt-get -yqq install docker-ce docker-ce-cli containerd.io docker-compose-plugin
      sudo apt-mark hold docker-ce docker-ce-cli
      sudo usermod -aG docker vagrant
      sudo usermod -aG docker ubuntu
      docker --version
      docker compose version
      "

      # Добавляем конфигурацию Docker
      machine.vm.provision "shell" do |dockerinit|
        dockerinit.inline = $docker_daemon_config
        dockerinit.args   = [DOCKER_INSECURE_REGISTRIES, DOCKER_REGISTRY_MIRRORS]
      end
      machine.vm.provision "shell", inline: "
      sudo systemctl restart docker
      sudo systemctl enable docker
      "

      # Создание сети для Nexus 3
      machine.vm.provision "shell", inline: "docker network create \"nexus\""

      # View VM info
      machine.vm.provision "shell", inline: "
      ip a | grep \"inet \"
      cat /etc/os-release
      hostnamectl
      hostname -I
      lscpu | grep VT-x
      ", run: "always"

      # # Перезагрузка
      # machine.vm.provision :reload

    end

end

# get-process | where ProcessName -like *ruby*
# get-process | findstr ruby
# $procid=get-process ruby |select -expand id
# $procid=(get-process ruby).id
# stop-process $procid
# stop-process 11222
