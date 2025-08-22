#!/usr/bin/env bash

# Install microk8s | istio
echo "Installing microk8s"
sudo snap install microk8s --classic
microk8s enable dashboard
microk8s status --wait-ready
microk8s enable dns
microk8s enable registry
microk8s enable community
microk8s enable ingress hostpath-storage
# microk8s enable istio ingress hostpath-storage
microk8s status
sudo usermod -a -G microk8s ubuntu
sudo chown -f -R ubuntu ~/.kube
newgrp microk8s
