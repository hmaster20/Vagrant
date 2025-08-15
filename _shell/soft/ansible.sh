#!/usr/bin/env bash

# # Install Ansible 2.9
# apt-get install -y software-properties-common
# sudo -E apt-add-repository ppa:ansible/ansible-2.9
# apt-get update -y
# apt-get install -y ansible sshpass
# ansible --version

# Install Ansible Latest
# sudo apt-get install -yq ansible=5.10.0-1ppa~focal
# apt-get remove -yq ansible
# add-apt-repository --yes --update ppa:ansible/ansible
apt-get install -yq ansible
ansible --version
