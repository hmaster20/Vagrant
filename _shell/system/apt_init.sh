#!/usr/bin/env bash

# Ansible
add-apt-repository --yes --update ppa:ansible/ansible

# CertBot Let’s Encrypt
apt-add-repository -r ppa:certbot/certbot

# # ClickHouse
# echo "deb http://nexus.local/repository/apt-clickhouse-arhive/ main/" > /etc/apt/sources.list.d/clickhouse.list

# Docker
sudo apt-get install -yq ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Helm
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install -y apt-transport-https --yes
echo \
  "deb https://baltocdn.com/helm/stable/debian/ all main \\" | \
  sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

# Kubernetes
# sudo apt-get install -y apt-transport-https ca-certificates curl
# sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
# echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
echo "kubernetes_install"
export packversion=$(sudo curl -L -s https://dl.k8s.io/release/stable.txt)
export shortversion=${packversion%.*}
sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/$shortversion/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$shortversion/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# # PostgreSQL
# echo "deb http://nexus.local/repository/apt-postgresql/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pg.list

# # Ubuntu Core
# echo "deb http://nexus.local/repository/apt-ubuntu-focal $(lsb_release -cs) main restricted" > /etc/apt/sources.list
# echo "deb http://nexus.local/repository/apt-ubuntu-focal $(lsb_release -cs)-updates main restricted" >> /etc/apt/sources.list
# echo "deb http://nexus.local/repository/apt-ubuntu-focal $(lsb_release -cs) universe" >> /etc/apt/sources.list
# echo "deb http://nexus.local/repository/apt-ubuntu-focal $(lsb_release -cs)-updates universe" >> /etc/apt/sources.list
# echo "deb http://nexus.local/repository/apt-ubuntu-focal $(lsb_release -cs) multiverse" >> /etc/apt/sources.list
# echo "deb http://nexus.local/repository/apt-ubuntu-focal $(lsb_release -cs)-updates multiverse" >> /etc/apt/sources.list
# echo "deb http://nexus.local/repository/apt-ubuntu-focal $(lsb_release -cs)-backports main restricted universe multiverse" >> /etc/apt/sources.list
# echo "deb http://nexus.local/repository/apt-ubuntu-security $(lsb_release -cs)-security main restricted" >> /etc/apt/sources.list
# echo "deb http://nexus.local/repository/apt-ubuntu-security $(lsb_release -cs)-security universe" >> /etc/apt/sources.list
# echo "deb http://nexus.local/repository/apt-ubuntu-security $(lsb_release -cs)-security multiverse" >> /etc/apt/sources.list

sudo apt-get update -yq
