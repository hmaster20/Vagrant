#!/usr/bin/env bash

# Install minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube
sudo install minikube /usr/local/bin/
minikube start --kubernetes-version v1.18.0 --cpus='2' --memory='2000mb' --disk-size='5000mb'
minikube status
