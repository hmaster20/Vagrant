# -*- mode: ruby -*-
# vi: set ft=ruby :

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


# 1. In Nexus, configure an apt proxy repo pointing at http://archive.ubuntu.com/ubuntu. Specify distribution "focal".
# 2. Start an Ubuntu 20.04 image.
# 3. Replace /etc/apt/sources.list with a new file with this content:

# deb http://NEXUSHOST/repository/APT_REPO_ID/ focal main
# 4. apt-get update
# 5. apt-get download firefox
# 6. Note the version of downloaded firefox
# 7. Update /etc/apt/sources.list to use the bionic distro:

# deb http://NEXUSHOST/repository/APT_REPO_ID/ bionic main
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
$apt_proxy=<<SCRIPT
cat <<EOF | sudo tee -a /etc/apt/apt.conf.d/00aptproxy
Acquire::http::Proxy "http://192.168.50.45:3142";
EOF
SCRIPT

# == Install plugin
# vagrant plugin install vagrant-reload
# ========================================================
# Before vagrant up, need run command to enable VT-X mode:
# cd C:\Program Files\Oracle\VirtualBox
# VBoxManage modifyvm <vm-name> --nested-hw-virt on
# ========================================================
# for info: https://stackoverflow.com/questions/54251855/virtualbox-enable-nested-vtx-amd-v-greyed-out
### configuration parameters ###
BOX_BASE = "ubuntu/focal64"
ADMIN_LOGIN = "ubuntu"
ADMIN_PASS = "ubuntu"

Vagrant.configure("2") do |config|

    # Базовый образ
    config.vm.box = BOX_BASE

    # # всегда используем небезопасный ключ Vagrant
    # config.ssh.insert_key = false
    # # перенаправляем ssh-агент, чтобы получить легкий доступ к разным узлам
    # config.ssh.forward_agent = true

    config.vm.define "nullvm.local" do |machine|
      machine.vm.hostname = "nullvm.local"

      machine.vm.provider "virtualbox" do |vbox|
        # https://www.virtualbox.org/manual/ch08.html
        vbox.customize ["modifyvm", :id, "--cpus", "2"]
        vbox.customize ["modifyvm", :id, "--cpuexecutioncap", "75"]
        vbox.customize ["modifyvm", :id, "--memory", "2048"]        # 3072 #4096
        vbox.customize ["modifyvm", :id, "--name", "nullvm.local"]
        vbox.customize ["modifyvm", :id, "--groups", "/local"]
        vbox.customize ["modifyvm", :id, "--description", "TEST APT repository for Ubuntu 20.04 LTS (Focal Fossa)"]
      end

      # WiFi (Static)
      # ==============
      # For check exist bridges:
      # C:\Program Files\Oracle\VirtualBox\VBoxManage.exe list bridgedifs

      machine.vm.network "public_network",
        bridge: 'Intel(R) Dual Band Wireless-AC 7260',
        ip: "192.168.1.133",
        :ipv6 => false,
        :mac => "080027C43B43"

      machine.vm.network "private_network", ip: "192.168.50.33", virtualbox__intnet: true

      # # delete default gw on eth0
      machine.vm.provision "shell", run: "always",
      inline: "sudo ip route del 0/0"

      # machine.vm.provision "shell", inline: "echo 'ubuntu:ubuntu' | sudo chpasswd"
      machine.vm.provision "shell" do |secure|
        secure.inline = "echo $1:$2 | chpasswd"
        secure.args   = [ADMIN_LOGIN, ADMIN_PASS]
      end

      # machine.vm.synced_folder ".", "/vagrant",  disabled: true
      # # https://www.vagrantup.com/docs/synced-folders/basic_usage
      # machine.vm.synced_folder "D:\\GitHub\\apps", "/application",
      #   disabled: false,
      #   # id: "ansible-project",
      #   # owner: ADMIN_LOGIN,
      #   # group: ADMIN_LOGIN,
      #   # mount_options: ["dmode=775,fmode=664"]
      #   mount_options: ["dmode=777,fmode=666"]

      # Enable remote access via password
      machine.vm.provision "shell", inline: <<-SHELL
      sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
      systemctl restart sshd.service
      SHELL

      # fix multipath daemon error
      # machine.vm.provision :shell, inline: $multipath_daemon, args: "#{master_ip}"
      machine.vm.provision :shell, inline: $multipath_daemon
      machine.vm.provision "shell", inline: "sudo systemctl restart multipathd.service"

      # Проксируем APT репозитории
      machine.vm.provision :shell, :inline => $apt_proxy

      # Install other tools
      # machine.vm.provision "shell", inline: "
      # sudo apt-get -yqq update && sudo apt-get -yqq upgrade
      # sudo apt-get install -yq --no-install-recommends \
      # htop iotop mc nano git net-tools dnsutils bash-completion jq
      # "

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

# get-process | where ProcessName -like *ruby*
# get-process | findstr ruby
# $procid=get-process ruby |select -expand id
# $procid=(get-process ruby).id
# stop-process $procid
# stop-process 11222
