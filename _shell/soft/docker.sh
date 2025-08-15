#!/usr/bin/env bash

# Install Docker
# ==============
# https://stackoverflow.com/questions/58741267/containerd-io-vs-docker-ce-cli-vs-docker-ce-what-are-the-differences-and-what-d
# containerd.io : демон containerd . Он работает независимо от пакетов докеров и требуется для пакетов докеров.
#   containerd доступен как демон для Linux и Windows. Он управляет полным жизненным циклом контейнера своей хост-системы, от передачи и хранения образов до выполнения и наблюдения за контейнером, низкоуровневого хранилища, сетевых подключений и т. д.
# docker-ce-cli : интерфейс командной строки для движка Docker, версия сообщества
# docker-ce : механизм докера , версия для сообщества. Требуется docker-ce-cli.
# ==============

# prepare for Docker
echo "prepare for Docker"
sudo apt install -yq apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release
# echo "$(lsb_release -cs)"
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

# Install Docker
echo "Installing Docker"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo apt-mark hold docker-ce docker-ce-cli
sudo usermod -aG docker vagrant
sudo usermod -aG docker ubuntu

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

sudo systemctl restart docker
sudo systemctl enable docker
