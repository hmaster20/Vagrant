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
CPU_COUNT = "2"     # vCores 2 4
CPU_USAGE = "75"    # Percent usage 75 95
RAM_SIZE = "3072"   # 1024 2048 3072 4096
# ---------------------------------
MAC_ADDR = "080027ABC174"
IP_ADDR = "192.168.1.174"      #  Bridge
IP_LOCL = "192.168.50.74"      #  Internal
IP_HOST = "192.168.56.74"      #  Host-Only
# ---------------------------------
HOST_ADDR = "slim-0.local"
VM_GROUP = "/local"
VM_DESCR = "TEST VM Ubuntu 20.04 LTS Focal"
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
# ---------------------------------
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
    "insecure-registries": [ ],
    "registry-mirrors": [ ],
    "storage-driver": "overlay2"
}
EOF
SCRIPT
# ---------------------------------
$yaml_syntax_nanorc=<<SCRIPT
cat <<EOF | sudo tee /usr/share/nano/yaml.nanorc > /dev/null
# Supports `YAML` files
syntax "YAML" "\.ya?ml$"
header "^(---|===)" "%YAML"

## Keys
color magenta "^\s*[\$A-Za-z0-9_-]+\:"
color brightmagenta "^\s*@[\$A-Za-z0-9_-]+\:"

## Values
color white ":\s.+$"
## Booleans
icolor brightcyan " (y|yes|n|no|true|false|on|off)$"
## Numbers
color brightred " [[:digit:]]+(\.[[:digit:]]+)?"
## Arrays
color red "\[" "\]" ":\s+[|>]" "^\s*- "
## Reserved
color green "(^| )!!(binary|bool|float|int|map|null|omap|seq|set|str) "

## Comments
color brightwhite "#.*$"

## Errors
color ,red ":\w.+$"
color ,red ":'.+$"
color ,red ":".+$"
color ,red "\s+$"

## Non closed quote
color ,red "['\"][^['\"]]*$"

## Closed quotes
color yellow "['\"].*['\"]"

## Equal sign
color brightgreen ":( |$)"
EOF
SCRIPT
# ---------------------------------

# echo "something" | sudo tee -a /etc/config_file
# echo "something" | sudo tee -a file > /dev/null

# == Install plugin
# vagrant plugin install vagrant-reload
# ========================================================


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
      # WiFi (DHCP)
      # machine.vm.network "public_network",
      #   bridge: 'Hyper-V Virtual Ethernet Adapter #2',
      #   :ipv6 => false,
      #   :mac => "080027C43B24"

      # WiFi (Static)
      # ==============
      # For check exist bridges:
      # C:\Program Files\Oracle\VirtualBox\VBoxManage.exe list bridgedifs
      # ==============
      # machine.vm.network "public_network",
      #   bridge: 'Intel(R) Dual Band Wireless-AC 7260',
      #   ip: IP_ADDR,
      #   :ipv6 => false,
      #   :mac => MAC_ADDR

      # machine.vm.network "private_network",
      #   virtualbox__intnet: true,
      #   ip: IP_LOCL,
      #   :ipv6 => false

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

      # fix (disable) auto upgrades
      machine.vm.provision "shell", inline: "
      sudo apt remove -yq unattended-upgrades
      sudo apt purge -y unattended-upgrades
      sudo apt remove -yq cron-apt
      "

      # Remove AppArmor
      machine.vm.provision "shell", inline: "
      sudo apt remove --assume-yes --purge apparmor
      "

      # Добавление подсветки Yaml в Nano
      machine.vm.provision :shell, inline: $yaml_syntax_nanorc
      # Install other tools
      # sudo apt-get -yqq update && sudo apt-get -yqq upgrade
      machine.vm.provision "shell", inline: "
      sudo apt-get -yqq update
      sudo apt-get install -yq --no-install-recommends \
      nano mc htop atop iotop iftop git net-tools dnsutils bash-completion \
      jq ncdu nload tmux tcpdump mlocate
      "

      # prepare for Docker
      machine.vm.provision "shell", inline: "
      echo \"prepare for Docker\"
      sudo apt install -yq apt-transport-https ca-certificates curl software-properties-common
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
      sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable\"
      "

      # Install Docker
      machine.vm.provision "shell", inline: "
      echo \"Installing Docker\"
      sudo apt-get -yqq install \
      docker-ce docker-ce-cli containerd.io \
      docker-buildx-plugin docker-compose-plugin
      sudo apt-mark hold docker-ce docker-ce-cli
      sudo usermod -aG docker vagrant
      sudo usermod -aG docker ubuntu
      docker --version
      docker compose version
      "

      # Добавляем конфигурацию Docker
      machine.vm.provision :shell, inline: $docker_daemon_config
      machine.vm.provision "shell", inline: "
      sudo systemctl restart docker
      sudo systemctl enable docker
      "

      # # Install Ansible 2.9
      # machine.vm.provision "shell", inline: "
      # apt-get install -y software-properties-common
      # sudo -E apt-add-repository ppa:ansible/ansible-2.9
      # apt-get update -y
      # apt-get install -y ansible sshpass
      # ansible --version
      # "

      # Install Ansible Latest
      # sudo apt-get install -yq ansible=5.10.0-1ppa~focal
      machine.vm.provision "shell", inline: "
      apt-get remove -yq ansible
      add-apt-repository --yes --update ppa:ansible/ansible
      apt-get install -yq ansible
      ansible --version
      "

      # View VM info
      machine.vm.provision "shell", inline: "
      ip a | grep \"inet \"
      cat /etc/os-release
      hostnamectl
      hostname -I
      lscpu | grep VT-x
      ", run: "always"

    end

end

# get-process | where ProcessName -like *ruby*
# get-process | findstr ruby
# $procid=get-process ruby |select -expand id
# $procid=(get-process ruby).id
# stop-process $procid
# stop-process 11222
