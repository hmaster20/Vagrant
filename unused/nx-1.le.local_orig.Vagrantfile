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
RAM_SIZE = "1024"   # 1024 2048 3072 4096
# ---------------------------------
MAC_ADDR = "080027ABC173"
IP_ADDR = "192.168.1.173"      #  Bridge
IP_LOCL = "192.168.50.73"      #  Internal
IP_HOST = "192.168.56.73"      #  Host-Only
# ---------------------------------
HOST_ADDR = "nx-1.le.local"
VM_GROUP = "/local"
VM_DESCR = "
Let’s Encrypt genrator SSL for *.it-enginer.ru
VM Ubuntu 20.04 LTS focal64
"
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
# Nexus DNS
$dns_host_record=<<SCRIPT
cat <<EOF | sudo tee -a /etc/hosts
192.168.56.44 nexus.local
EOF
SCRIPT
# ---------------------------------
# Nexus PATH
NEXUS_REPO = "./../nexus.local/nexus-config/repo"
NEXUS_GPG = "./../nexus.local/nexus-config/gpg"
# ---------------------------------
# DOCKER_INSECURE_REGISTRIES='"192.168.56.44:8082","172.17.21.109:5000"'
# DOCKER_REGISTRY_MIRRORS='"http://192.168.56.44:8082"'
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
      "nexus.local:8082",
      "nexus.local:8083"
    ],
    "registry-mirrors": [
      "http://nexus.local:8082"
    ],
    "storage-driver": "overlay2"
}
EOF
SCRIPT
# ---------------------------------
# ---------------------------------

# echo "something" | sudo tee -a /etc/config_file
# echo "something" | sudo tee -a file > /dev/null


# 1. In Nexus, configure an apt proxy repo pointing at
#    http://archive.ubuntu.com/ubuntu. Specify distribution "focal".
# 2. Start an Ubuntu 20.04 image.
# 3. Replace /etc/apt/sources.list with a new file with this content:
#    deb http://NEXUSHOST/repository/APT_REPO_ID/ focal main
# 4. apt-get update
# 5. apt-get download firefox
# 6. Note the version of downloaded firefox
# 7. Update /etc/apt/sources.list to use the bionic distro:
#    deb http://NEXUSHOST/repository/APT_REPO_ID/ bionic main
# 8. apt-get update

# Switch to super user: su
# Add the new repository to apt's list of repos: echo "deb https://repository.domain.com/repository/REPO_NAME/ xenial main" >> /etc/apt/sources.list.d/your-custom.list: 
# Add the auth part I: echo "machine repository.domain.com" >> /etc/apt/auth.conf
# Add the auth part II: echo "login $NEXUS_USERNAME" >> /etc/apt/auth.conf
# Add the auth part III: echo "password $NEXUS_PASSWORD" >> /etc/apt/auth.conf
# Import the public key of the private key used for signing: apt-key adv --keyserver keyserver.ubuntu.com --recv-keys YOUR_PUBLIC_KEY_ID
# Update apt: apt-get update
# Install package: apt-get install package
# There might be an issue with access to the repository.

# стучится на http://security.ubuntu.com/ubuntu, потому что, скорее всего, этот адрес в /etc/apt/sources.list
# можешь http://192.168.66.226:8081/repository/apt/ прописать в /etc/apt/sources.list, 
# прокси не задавать вообще, а в настройку нексуса Remote storage написать нужный репо, 
# например https://mirror.yandex.ru/ubuntu-releases/ или http://archive.ubuntu.com/ubuntu/


# Передача ключей в изолирвоанной среде мдет через Squid
# sudo apt-key adv --keyserver keyserver.ubuntu.com --keyserver-options http-proxy=http://localhost:3128 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886

# Acquire::http::Proxy "http://192.168.50.32:3142";
# Acquire::https::Proxy "http://user:password@proxy.server:port/";
# Acquire::http::Proxy "http://nexus.stage.local/repository/apt-ubuntu-focal";
# Acquire::http::Proxy "http://nexus.stage.local/repository/apt-ubuntu-focal/";
# Acquire::http::Proxy "http://192.168.50.32:3142";
# $apt_proxy=<<SCRIPT
# cat <<EOF | sudo tee -a /etc/apt/apt.conf.d/00aptproxy
# Acquire::http::Proxy "http://192.168.50.45:3142";
# EOF
# SCRIPT

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

      # fix auto upgrades
      machine.vm.provision "shell", inline: "
      sudo apt remove -yq unattended-upgrades
      sudo apt purge -y unattended-upgrades
      sudo apt remove -yq cron-apt
      "

      # delete default gw on eth0
      # machine.vm.provision "shell", run: "always", inline: "sudo ip route del 0/0"

      # Проксируем APT репозитории
      # machine.vm.provision :shell, :inline => $apt_proxy

      # Nexus DNS
      machine.vm.provision :shell, inline: $dns_host_record

      # ---------------------------------------------------------------------
      machine.vm.provision "file", 
        source: "#{NEXUS_REPO}/sources.list", 
        destination: "/tmp/sources.list"
      machine.vm.provision "shell", inline: "mv /tmp/sources.list /etc/apt/sources.list"

      machine.vm.provision "file", 
        source: "#{NEXUS_REPO}/clickhouse.list", 
        destination: "/tmp/clickhouse.list"
      machine.vm.provision "shell", inline: "mv /tmp/clickhouse.list /etc/apt/sources.list.d/clickhouse.list"

      machine.vm.provision "file", 
        source: "#{NEXUS_REPO}/pg.list", 
        destination: "/tmp/pg.list"
      machine.vm.provision "shell", inline: "mv /tmp/pg.list /etc/apt/sources.list.d/pg.list"

      machine.vm.provision "file", 
        source: "#{NEXUS_REPO}/ansible.list", 
        destination: "/tmp/ansible.list"
      machine.vm.provision "shell", inline: "mv /tmp/ansible.list /etc/apt/sources.list.d/ansible.list"

      machine.vm.provision "file", 
        source: "#{NEXUS_REPO}/docker.list", 
        destination: "/tmp/docker.list"
      machine.vm.provision "shell", inline: "mv /tmp/docker.list /etc/apt/sources.list.d/docker.list"

      machine.vm.provision "file", 
        source: "#{NEXUS_REPO}/kubernetes.list", 
        destination: "/tmp/kubernetes.list"
      machine.vm.provision "shell", inline: "mv /tmp/kubernetes.list /etc/apt/sources.list.d/kubernetes.list"

      machine.vm.provision "file", 
        source: "#{NEXUS_REPO}/helm.list", 
        destination: "/tmp/helm.list"
      machine.vm.provision "shell", inline: "mv /tmp/helm.list /etc/apt/sources.list.d/helm.list"

      machine.vm.provision "file", 
        source: "#{NEXUS_REPO}/pip.conf", 
        destination: "/tmp/pip.conf"
      machine.vm.provision "shell", inline: "mv /tmp/pip.conf /etc/pip.conf"

      # ---------------------------------------------------------------------
      machine.vm.provision "file", 
        source: "#{NEXUS_GPG}/CLICKHOUSE.GPG", 
        destination: "/tmp/CLICKHOUSE.GPG"
      machine.vm.provision "shell", inline: "sudo apt-key add /tmp/CLICKHOUSE.GPG"

      machine.vm.provision "file", 
        source: "#{NEXUS_GPG}/PG.GPG", 
        destination: "/tmp/PG.GPG"
      machine.vm.provision "shell", inline: "sudo apt-key add /tmp/PG.GPG"

      machine.vm.provision "file", 
        source: "#{NEXUS_GPG}/ANSIBLE.GPG", 
        destination: "/tmp/ANSIBLE.GPG"
      machine.vm.provision "shell", inline: "sudo apt-key add /tmp/ANSIBLE.GPG"

      machine.vm.provision "file", 
        source: "#{NEXUS_GPG}/DOCKER.GPG", 
        destination: "/tmp/DOCKER.GPG"
      machine.vm.provision "shell", inline: "sudo apt-key add /tmp/DOCKER.GPG"

      machine.vm.provision "file", 
        source: "#{NEXUS_GPG}/K8S.GPG", 
        destination: "/tmp/K8S.GPG"
      machine.vm.provision "shell", inline: "sudo apt-key add /tmp/K8S.GPG"

      machine.vm.provision "file", 
        source: "#{NEXUS_GPG}/HELM.GPG", 
        destination: "/tmp/HELM.GPG"
      machine.vm.provision "shell", inline: "sudo apt-key add /tmp/HELM.GPG"
      # ---------------------------------------------------------------------

      # Install other tools
      # sudo apt-get -yqq update && sudo apt-get -yqq upgrade
      machine.vm.provision "shell", inline: "
      sudo apt-get -yqq update
      sudo apt-get install -yq --no-install-recommends \
      nano mc htop atop iotop iftop git net-tools dnsutils bash-completion \
      jq ncdu nload tmux tcpdump mlocate
      "

      # Добавляем конфигурацию Docker
      machine.vm.provision "shell", inline: "
      sudo apt-add-repository -r ppa:certbot/certbot
      sudo apt-get -yqq update
      sudo apt-get install -yq --no-install-recommends python3-certbot-nginx
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
