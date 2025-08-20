# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Before vagrant up, need run command to enable VT-X mode:
# cd C:\Program Files\Oracle\VirtualBox
# VBoxManage modifyvm <vm-name> --nested-hw-virt on
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# for info: https://stackoverflow.com/questions/54251855/virtualbox-enable-nested-vtx-amd-v-greyed-out
# ---------------------------------
BOX_BASE = "ubuntu/focal64"
ADMIN_LOGIN = "ubuntu"
ADMIN_PASS = "ubuntu"
# ---------------------------------
MAC_ADDR = "080027ABC161"
IP_ADDR = "192.168.1.161"
HOST_ADDR = "selfhosted20.custom.local"
VM_GROUP = "/addreality"
VM_DESCR = "Server Addreality \nFor test local instance"
# ---------------------------------
CPU_COUNT = "2"
CPU_USAGE = "90"    # Percent usage
RAM_SIZE = "3072"   #  4096
# ---------------------------------
EXT_DISK = './ExtDisk.vdi'
EXT_DISK_SIZE = 10 * 1024

# disk = './secondDisk.vdi'
# second_disk = './secondDisk.vdi'


Vagrant.configure("2") do |config|

    config.vm.box = BOX_BASE
   
    config.vm.define "selfhosted20.custom.local" do |machine|
      machine.vm.hostname = "selfhosted20.custom.local"

      machine.vm.provider "virtualbox" do |vbox|
        # https://www.virtualbox.org/manual/ch08.html
        vbox.customize ["modifyvm", :id, "--cpus", CPU_COUNT ]
        vbox.customize ["modifyvm", :id, "--cpuexecutioncap", CPU_USAGE ]
        vbox.customize ["modifyvm", :id, "--memory", RAM_SIZE ]
        vbox.customize ["modifyvm", :id, "--name", HOST_ADDR ]
        vbox.customize ["modifyvm", :id, "--groups", VM_GROUP ]
        vbox.customize ["modifyvm", :id, "--description", VM_DESCR ]

        # unless File.exist?(disk)
        #   # vbox.customize ['createhd', '--filename', disk, '--variant', 'Fixed', '--size', 20 * 1024]
        #   vbox.customize ['createhd', '--filename', disk, '--variant', 'Fixed', '--size', 20 * 1024]
        # end

        # vbox.customize ['createhd', '--filename', './sDisk.vdi', '--size', 4096]
        # vbox.customize ['createhd', '--filename', './sfDisk.vdi', '--variant', 'Fixed', '--size', 4096]
        # vbox.customize ['storageattach', :id, '--storagectl', 'SCSI', '--port', 3, '--device', 0, '--type', 'hdd', '--medium', './sfDisk.vdi']

        # Create and attach disk
        # https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/vboxmanage-createmedium.html
        # https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/vboxmanage-storageattach.html
        unless File.exist?(EXT_DISK)
          # vbox.customize ['createhd', '--filename', EXT_DISK , '--variant', 'Fixed', '--size', EXT_DISK_SIZE ]
          # vbox.customize ['createhd', '--filename', EXT_DISK , '--format', 'VDI', '--size', EXT_DISK_SIZE ]
          vbox.customize ['createmedium', '--filename', EXT_DISK , '--format', 'VMDK', '--size', EXT_DISK_SIZE ]
        end
        vbox.customize ['storageattach', :id, 
                        '--storagectl', 'SCSI', 
                        '--port', 2, 
                        '--device', 0, 
                        '--type', 'hdd',  # dvddrive|hdd|fdd]
                        '--medium', 
                        EXT_DISK ]



        # disk_test = File.realpath( "." ).to_s + "/disk.vdi"
        # unless File.exist?(disk_test)
        #   vbox.customize ['createhd', '--filename', disk_test , '--variant', 'Fixed', '--size', 40960]
        # end
        # # https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/vboxmanage-storageattach.html
        # vbox.customize ['storageattach', :id, 
        #                 '--storagectl', 'SCSI', 
        #                 '--port', 2, 
        #                 '--device', 0, 
        #                 '--type', 'hdd', 
        #                 '--medium', 
        #                 disk_test ]



      # # Create and attach disk
      # unless File.exist?(second_disk)
      #   vbox.customize ['createhd', '--filename', second_disk, '--variant', 'Fixed', '--size', 1024]
      #   # vbox.customize ['createhd', '--filename', second_disk, '--format', 'VDI', '--size', 50 * 1024]        
      # end
      # # vbox.customize ['storageattach', :id, '--storagectl', 'IDE Controller', '--port', 0, '--device', 1, '--type', 'hdd', '--medium', second_disk]
      # # vbox.customize ['storageattach', :id, '--storagectl', 'scsi', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', second_disk]

        # file_to_disk = File.realpath( "." ).to_s + "/disk.vdi"

        # if ARGV[0] == "up" && ! File.exist?(file_to_disk)
        #    vbox.customize [
        #         'createhd',
        #         '--filename', file_to_disk,
        #         '--format', 'VDI',
        #         '--size', 30 * 1024 # 30 GB
        #         ]
        #    vbox.customize [
        #         'storageattach', :id,
        #         '--storagectl', 'SATAController',
        #         '--port', 1, '--device', 0,
        #         '--type', 'hdd', '--medium',
        #         file_to_disk
        #         ]
        # end


        # Отключить проверку гостевый дополнений
        vbox.check_guest_additions = false

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

      # machine.vm.provision "shell", inline: "echo 'ubuntu:ubuntu' | sudo chpasswd"
      machine.vm.provision "shell" do |secure|
        secure.inline = "echo $1:$2 | chpasswd"
        secure.args   = [ADMIN_LOGIN, ADMIN_PASS]
      end

      # https://www.vagrantup.com/docs/synced-folders/basic_usage
      machine.vm.synced_folder "D:\\GitHub\\apps", "/application", 
        disabled: false,
        # id: "ansible-project",
        # owner: ADMIN_LOGIN,
        # group: ADMIN_LOGIN,
        # mount_options: ["dmode=775,fmode=664"]
        mount_options: ["dmode=777,fmode=666"]

      # Enable remote access via password
      machine.vm.provision "shell", inline: <<-SHELL
      sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
      systemctl restart sshd.service
      SHELL
      
      # Install other tools
      machine.vm.provision "shell", inline: "
      sudo apt-get -yqq update
      sudo apt-get install -yq --no-install-recommends \
      htop iotop iftop mc nano git net-tools dnsutils bash-completion
      "

      # Install VirtualBox and Extension Pack
      # machine.vm.provision "shell", inline: "
      # sudo apt install -y gcc make linux-headers-$(uname -r) dkms
      # sudo apt-get install -y software–properties–common
      # sudo sed -i 's%GPG_CMD=\"gpg %GPG_CMD=\"gpg --batch %g' /usr/bin/apt-key
      # export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=true
      # wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
      # wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
      # echo \"deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib\" | sudo tee /etc/apt/sources.list.d/virtualbox.list
      # sudo apt-get -y update
      # export packversion=$(curl -s https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT)
      # export shortversion=${packversion%.*}
      # printenv shortversion
      # sudo apt install -y virtualbox-$shortversion
      # sudo curl -LO https://download.virtualbox.org/virtualbox/`curl -s https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT`/Oracle_VM_VirtualBox_Extension_Pack-`curl -s https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT`.vbox-extpack
      # echo \"y\" | sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-`curl -s https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT`.vbox-extpack
      # "

      # machine.vm.provision "shell", inline: "apt-get update && apt-get install -y python-minimal"
      # machine.vm.provision "ansible", playbook: "consul.yml"

      # # Install Ansible 2.9
      # machine.vm.provision "shell", inline: "
      # apt-get update && apt-get install -y python-minimal
      # apt-get install -y software-properties-common
      # apt-add-repository ppa:ansible/ansible -y
      # apt-get update -y
      # apt-get install -y ansible sshpass
      # ansible --version
      # "

      # # Install Docker
      # machine.vm.provision "shell", inline: "
      # echo \"Installing Docker\"
      # echo \"Without setup bionic may be used $(lsb_release -cs)\"
      # sudo apt-get -yqq update && sudo apt-get -yqq upgrade
      # sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
      # sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable\"
      # sudo apt-get -yqq update
      # sudo apt-get -yqq install docker-ce
      # sudo usermod -aG docker vagrant
      # docker --version
      # "

      # # Install Docker Compose
      # machine.vm.provision "shell", inline: "
      # echo \"Installing Docker Compose\"
      # echo \"Without setup docker-compose-Linux-x86_64 may be used docker-compose-$(uname -s)-$(uname -m)\"
      # sudo curl -L \"https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64\" -o /usr/local/bin/docker-compose
      # sudo chmod +x /usr/local/bin/docker-compose
      # sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
      # docker-compose --version
      # "

      # Install Kubectl
      # machine.vm.provision "shell", inline: "
      # sudo apt-get update -y
      # sudo apt-get install -y curl apt-transport-https
      # sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
      # sudo chmod +x ./kubectl
      # sudo mv ./kubectl /usr/local/bin/kubectl
      # kubectl version --client
      # "

      # Install Helm
      # machine.vm.provision "shell", inline: "
      # curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
      # sudo apt-get install -y apt-transport-https --yes
      # echo \"deb https://baltocdn.com/helm/stable/debian/ all main\" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
      # sudo apt-get update -y
      # sudo apt-get install -y helm
      # "

      # Install minikube
      # machine.vm.provision "shell", inline: "
      # curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube
      # sudo install minikube /usr/local/bin/
      # minikube start --kubernetes-version v1.18.0 --cpus='2' --memory='2000mb' --disk-size='5000mb'
      # minikube status
      # "

      # fix multipath daemon error
      # https://sleeplessbeastie.eu/2021/01/06/how-to-fix-multipath-daemon-error-about-missing-path-when-using-virtualbox/
      machine.vm.provision "shell", inline: "
      cat <<EOF | sudo tee -a /etc/multipath.conf
      blacklist {
        device {
          vendor \"VBOX\"
          product \"HARDDISK\"
        }
      }
      EOF
      sudo systemctl restart multipathd.service
      "


  config.vm.provision "shell", inline: <<-SHELL
set -e
set -x

if [ -f /etc/provision_env_disk_added_date ]
then
   echo "Provision runtime already done."
   exit 0
fi


sudo fdisk -u /dev/sdc <<EOF
n
p
1

+500M
n
p
2


w
EOF

mkfs.ext4 /dev/sdc1
mkfs.ext4 /dev/sdc2
mkdir -p /{data,extra}
mount -t ext4 /dev/sdc1 /data
mount -t ext4 /dev/sdc2 /extra

date > /etc/provision_env_disk_added_date
  SHELL



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
