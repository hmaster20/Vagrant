# -*- mode: ruby -*-
# vi: set ft=ruby :
# ---------------------------------
# https://stackoverflow.com/questions/54251855/virtualbox-enable-nested-vtx-amd-v-greyed-out
# Before vagrant up, need run command to enable VT-X mode:
# cd C:\Program Files\Oracle\VirtualBox
# VBoxManage modifyvm <vm-name> --nested-hw-virt on
# ---------------------------------
# == Install plugin
# vagrant plugin install vagrant-reload
# ---------------------------------
# BOX_BASE = "ubuntu/focal64" # 20.04
BOX_BASE = "ubuntu/jammy64" # 22.04
ADMIN_LOGIN = "ubuntu"
ADMIN_PASS = "ubuntu"
# ---------------------------------
CPU_COUNT = "2"     # vCores 2 4
CPU_USAGE = "75"    # Percent usage 75 95
RAM_SIZE = "1024"   # 1024 2048 3072 4096
# ---------------------------------
MAC_ADDR = "080027ABC167"
IP_ADDR = "192.168.1.167"      #  Bridge
IP_LOCL = "192.168.50.67"      #  Internal
IP_HOST = "192.168.56.67"      #  Host-Only
# ---------------------------------
HOST_ADDR = "nx-0.local"
VM_GROUP = "/local"
# VM_DESCR = "TEST VM Ubuntu 20.04 LTS Focal"
VM_DESCR = "TEST VM Ubuntu 22.04 LTS Focal"
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

      # delete default gw on eth0
      machine.vm.provision "shell", run: "always", inline: "sudo ip route del 0/0"

      # Проксируем APT репозитории
      # machine.vm.provision :shell, :inline => $apt_proxy

      # Nexus DNS
      machine.vm.provision "shell", inline: $dns_host_record

      # fix (disable) auto upgrades
      # machine.vm.provision "shell", path: "../../_shell/disable_auto_upgrades.sh"

      # ---------------------------------------------------------------------
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

      # apt
      machine.vm.provision "shell", path: "../../_shell/system/apt_init_nexus.sh"

      # Install other tools
      machine.vm.provision "shell", path: "../../_shell/system/common_apt_u2204.sh"

      # Добавление подсветки Yaml в Nano
      machine.vm.provision "shell", path: "../../_shell/soft/nanorc_yaml.sh"

      # Install Docker
      machine.vm.provision "shell", path: "../../_shell/soft/docker.sh"

      # Добавляем конфигурацию Docker
      machine.vm.provision :shell, inline: $docker_daemon_config
      machine.vm.provision "shell", inline: "
      sudo systemctl restart docker
      sudo systemctl enable docker
      "

      # Install Ansible
      machine.vm.provision "shell", path: "../../_shell/soft/ansible.sh"

      # View VM info
      machine.vm.provision "shell", path: "../../_shell/view_vm_info.sh", run: "always"

    end

end

# get-process | where ProcessName -like *ruby*
# get-process | findstr ruby
# $procid=get-process ruby |select -expand id
# $procid=(get-process ruby).id
# stop-process $procid
# stop-process 11222
