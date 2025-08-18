#!/usr/bin/env bash

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
