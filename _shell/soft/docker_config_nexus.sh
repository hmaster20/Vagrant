#!/usr/bin/env bash

# echo "something" | sudo tee -a /etc/config_file
# echo "something" | sudo tee -a file > /dev/null

# Docker config for used Nexus
# DOCKER_INSECURE_REGISTRIES='"192.168.56.44:8082","172.17.21.109:5000"'
# DOCKER_REGISTRY_MIRRORS='"http://192.168.56.44:8082"'

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
    "max-concurrent-downloads": 3,
    "max-concurrent-uploads": 5,
    "registry-mirrors": [
      "http://nexus.local:8082"
    ],
    "storage-driver": "overlay2"
}
EOF

sudo systemctl restart docker
sudo systemctl enable docker
