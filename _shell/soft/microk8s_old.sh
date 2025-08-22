#!/usr/bin/env bash

# https://microk8s.io/?utm_source=blog&_ga=2.148390641.712030040.1666732418-322807145.1643707324

# Install MicroK8s on Linux
sudo snap install microk8s --classic

# Check the status while Kubernetes starts
microk8s status --wait-ready

# Turn on the services you want
microk8s enable dashboard dns registry istio

# If RBAC is not enabled access the dashboard using the token retrieved with:
# microk8s kubectl describe secret -n kube-system microk8s-dashboard-token
# Use this token in the https login UI of the kubernetes-dashboard service.
# In an RBAC enabled setup (microk8s enable RBAC) you need to create a user with restricted permissions as shown in: https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md

# Start using Kubernetes
microk8s kubectl get all --all-namespaces

# Access the Kubernetes dashboard
microk8s dashboard-proxy

# Start and stop Kubernetes to save battery
microk8s start
microk8s stop




# how to deploy portainer onmicrok8s
# https://www.portainer.io/blog/how-to-deploy-portainer-on-microk8s

 microk8s enable dns ingress rbac hostpath-storage
 microk8s status

# Включение репозитория
microk8s enable community

microk8s enable portainer

microk8s kubectl get pods -n portainer

export NODE_PORT=$(microk8s kubectl get --namespace portainer -o jsonpath="{.spec.ports[1].nodePort}" services portainer)
export NODE_IP=$(microk8s kubectl get nodes --namespace portainer -o jsonpath="{.items[0].status.addresses[0].address}")
echo https://$NODE_IP:$NODE_PORT

# По сути нужен только порт и будем подключатсья в формате:
https://192.168.1.106:30779




#########################

# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

# Update the apt package index and install packages needed to use the Kubernetes apt repository:
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
# Download the Google Cloud public signing key:
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
# Add the Kubernetes apt repository:
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
# Update apt package index, install kubelet, kubeadm and kubectl, and pin their version:
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl


###############

# https://kifarunix.com/install-pritunl-vpn-client-on-debian-ubuntu/





    `microk8s enable storage ingress helm3 dashboard metrics-server prometheus`

     microk8s enable dns registry ingress hostpath-storage
dashboard
      WARNING: Hostpath storage is not suitable for production environments.



microk8s inspect

sudo apt-get install -yq iptables-persistent
sudo iptables -P FORWARD ACCEPT

sudo chmod 777 -R  /etc/iptables/

sudo iptables-save > /etc/iptables/rules.v4
sudo ip6tables-save > /etc/iptables/rules.v6

sudo chmod 755 -R  /etc/iptables/

sudo netfilter-persistent save
sudo netfilter-persistent reload

sudo touch /etc/docker/daemon.json
sudo nano /etc/docker/daemon.json
{
    "insecure-registries" : ["localhost:32000"]
}
sudo systemctl restart docker

WARNING:  This machine's hostname contains capital letters and/or underscores.
          This is not a valid name for a Kubernetes node, causing node registration to fail.
          Please change the machine's hostname or refer to the documentation for more details:
          https://microk8s.io/docs/troubleshooting#heading--common-issues

sudo nano /etc/hostname
sudo nano /etc/hosts
sudo reboot
hostname
hostnamectl

# hostnamectl set-hostname <new-hostname>
```

   microk8s enable dashboard

   If RBAC is not enabled access the dashboard using the token retrieved with:

microk8s kubectl describe secret -n kube-system microk8s-dashboard-token

Use this token in the https login UI of the kubernetes-dashboard service.

In an RBAC enabled setup (microk8s enable RBAC) you need to create a user with restricted
permissions as shown in:
https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md

`microk8s enable metallb:192.168.1.61-192.168.1.81`

microk8s kubectl get endpoints -n metallb-system
microk8s kubectl -n metallb-system get secret webhook-server-cert -ojsonpath='{.data.ca\.crt}' | base64 -d
microk8s kubectl get service -n metallb-system  webhook-service

      # sudo snap install microk8s --classic --channel=1.25
      # --channel=1.19
      # https://microk8s.io/docs/setting-snap-channel
      # snap install microk8s --classic --channel=1.24/stable

      # sudo snap install microk8s --classic --channel=1.19/stable
      # 1.19/stable


      # sudo snap install microk8s --classic --channel=1.23/stable
      # microk8s disable ha-cluster --force

