# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.network "private_network", ip: "192.168.56.79"
  config.vm.synced_folder "./sites", "/vagrant/sites", type: "virtualbox", mount_options: ["dmode=775,fmode=664,uid=33,gid=33"] # uid=33 = www-data в контейнере

  # Установка Docker, Docker Compose и запуск проекта
  config.vm.provision "shell", inline: <<-SHELL
    # Установка Docker
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io
      
    # Установка Docker Compose
    curl -L "https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
      
      # Запуск проекта (через 10 секунд после старта)
      (sleep 10 && cd /vagrant && docker-compose up -d) &
  SHELL
end